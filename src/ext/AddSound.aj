package ext;
import java.io.IOException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;

import battleship.*;
import battleship.model.*;

/**Play a song when a place of a board is hit.
 * Play a sound when a ship is sunk
 * @author ajgarcia09
 *
 */
/*Hint: You may use the following code snippet to play an audio
clip. It assumes that audio files are stored in the directory
src/sounds.*/

 /** Directory where audio files are stored. */



public aspect AddSound {
	
	 private static final String SOUND_DIR = "../src/sounds";
	 private static final String boardHitSound = "impact.mp3"; 
	
	pointcut boardWasHit(): 
		call(void Board.notifyHit(Place,int));
		
	
	after(): boardWasHit(){
		System.out.println("Board was hit!!");
		playAudio(boardHitSound);
	}
	
	pointcut shipWasSunk():
		call(void Board.notifyShipSunk(Ship));
	
	after(): shipWasSunk(){
		System.out.println("Ship was sunk!!");
	}
		
	 /** Play the given audio file. Inefficient because a file will be 
	  * (re)loaded each time it is played. */
	 public static void playAudio(String filename) {
	   try {
	       AudioInputStream audioIn = AudioSystem.getAudioInputStream(
		    AddSound.class.getResource(SOUND_DIR + filename));
	       Clip clip = AudioSystem.getClip();
	       clip.open(audioIn);
	       clip.start();
	   } catch (UnsupportedAudioFileException 
	         | IOException | LineUnavailableException e) {
	       e.printStackTrace();
	   }
	 }
		

}
