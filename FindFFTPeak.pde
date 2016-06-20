 
import ddf.minim.analysis.*;
import ddf.minim.*;
  
Minim minim;
AudioPlayer sound;
FFT fftLin;
int bufferSize=2048;
int arrayLen;
int index=0;
int count=0;
int timeSec;
int totalSamp;
int numFrames;
int peakBin;
float pitch;
int midi_value;
float[] bandArray = new float[1025];
float[] freqArray = new float[1025];
int[] notesArray;
IntList notes_in_midi_form;
 
void setup()
{
 
  // create a screen width=512, height=256
  size(512, 256);
  
  // create a minim audio application object
  minim = new Minim(this);

  // create a file object (can be a MP3 file or a WAV file)
  //sound = minim.loadFile("singleTone2.wav", bufferSize);
  sound = minim.loadFile("sight_singing1.mp3", bufferSize);
 
  // loop the file
  sound.play();
  //this is not needed at the moment
  timeSec=sound.length();
  totalSamp=timeSec* (int) floor(sound.sampleRate());
  numFrames=floor(totalSamp/sound.bufferSize());

  notes_in_midi_form = new IntList();
  //int[] notesArray=new int[numFrames];
  // create an FFT object that has a time-domain buffer the same size as sound's sample buffer
  // note that this needs to be a power of two
  // and that it means the size of the spectrum will be 1024.
  // see the online tutorial for more info.
  fftLin = new FFT(sound.bufferSize(), sound.sampleRate());
  makeFreqArray();
  }
  
void draw()
{
//get the FFT of the audio data in the buffer
  fftLin.forward(sound.mix);
  //find the amplitude at each analysis freuqency
  for (int i=0;i<fftLin.specSize();i++){
    bandArray[i]=fftLin.getBand(i);
  }
  
    peakBin=findmaxPeak(); //find at which frequency index is the peak value
    pitch=freqArray[peakBin]; //convert to hertz
    midi_value=(int) round((69+12*log(pitch/440)/log(2))); //conveet that to a midi note
    if ((midi_value)>0 && fftLin.getBand(peakBin)>1){
      notes_in_midi_form.append(midi_value); //create a list of the pitches of the notes determined as midi values
      //println(midi_value);
    }
  }
  
 int findmaxPeak(){
   int bin=0;
   float highest=0;
  for (int binN=0;binN<bandArray.length;binN++){
   if (bandArray[binN]>highest){
     bin=binN;
     highest=bandArray[binN];     
   } 
    }
  return bin;
 }
void makeFreqArray(){
freqArray[0]=0;
  for (int i=1;i<fftLin.specSize();i++){
    freqArray[i]=freqArray[i-1]+(sound.sampleRate()/sound.bufferSize());
  }
}

@ Override public void stop()
{
  int N=(notes_in_midi_form.size());
  for (int n=0;n<N;n++){
    println(notes_in_midi_form.get(n));
  }

  // always close Minim audio classes when you are done with them
  sound.close();
// always stop Minim before exiting
  minim.stop();
super.stop();

} 

//void stop()
@ Override public void exit() {
  // Call finalizing stuff below:
  // ...
  int N=(notes_in_midi_form.size());
  for (int n=0;n<N;n++){
    println(notes_in_midi_form.get(n));
  }
// always close Minim audio classes when you are done with them
  sound.close();
// always stop Minim before exiting
  minim.stop();

  super.stop(); // Now call original exit()
}