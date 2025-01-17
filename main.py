import time
from flask import Flask, request, jsonify, send_file
import numpy as np
from scipy.io import wavfile
from gtts import gTTS
import io
from faster_whisper import WhisperModel
from RAG import AIVoiceAssistant
from concurrent.futures import ThreadPoolExecutor
from transformers import WhisperProcessor, WhisperForConditionalGeneration, AutoTokenizer
import soundfile as sf
import torch

# Flask app setup
app = Flask(__name__)

# Initialize AI Assistant and Whisper Model
ai_assistant = AIVoiceAssistant()
model = WhisperModel("tiny", device="cpu", compute_type="int8", num_workers=10)

def is_silence(data, max_amplitude_threshold=2000):
    """Check if the audio data contains silence."""
    sample_data = data[::10]  # Downsample for efficiency
    max_amplitude = np.max(np.abs(sample_data))
    return max_amplitude <= max_amplitude_threshold

def transcribe_audio(audio_path):
    start_time=time.time()
    model_repo = "shReYas0363/whisper-tiny-fine-tuned"
 
    processor = WhisperProcessor.from_pretrained("openai/whisper-tiny")
    model = WhisperForConditionalGeneration.from_pretrained(model_repo)
    
    # Move model to GPU if available
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model = model.to(device)
    
    
    audio_input, sampling_rate = sf.read(audio_path)
    
    # Convert to mono if stereo
    if len(audio_input.shape) > 1:
        audio_input = audio_input.mean(axis=1)
    

    input_features = processor(
        audio_input, 
        sampling_rate=sampling_rate, 
        return_tensors="pt"
    ).input_features
    input_features = input_features.to(device)
    
   
    predicted_ids = model.generate(input_features)
    transcription = processor.batch_decode(
        predicted_ids, 
        skip_special_tokens=True
    )[0]

    end_time = time.time()  # End the timer
    response_time = end_time - start_time

    print("whisper responce time",response_time )
    
    return transcription

@app.route('/upload-audio', methods=['POST'])
def upload_audio():
    if 'audio' not in request.files:
        return jsonify({"error": "No audio file provided"}), 400

    file = request.files['audio']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file and file.filename.endswith('.wav'):
        try:
            # Read the WAV file into memory
            file_content = file.read()
            temp_wav_path = io.BytesIO(file_content)

            # Check if audio chunk is silent
            samplerate, data = wavfile.read(temp_wav_path)
            if is_silence(data):
                return jsonify({"response": "Silence detected, please speak clearly."})

            # Transcribe and get transcription text
            transcription = transcribe_audio(temp_wav_path)

            if transcription:
                # Process AI response synchronously
                response = ai_assistant.interact_with_llm(transcription)
                if response:
                    response = response.strip()
                    # Generate TTS output
                    tts = gTTS(text=response, lang='en-IN', tld='co.in')
                    audio_stream = io.BytesIO()
                    tts.write_to_fp(audio_stream)
                    audio_stream.seek(0)  # Reset stream position

                    return send_file(audio_stream, mimetype='audio/mpeg')
        except Exception as e:
            print(f"Error processing audio file: {e}")
            return jsonify({"error": "Error processing the audio file."}), 500

    return jsonify({"error": "Invalid file type. Please upload a WAV file."}), 400

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000, debug=True)
