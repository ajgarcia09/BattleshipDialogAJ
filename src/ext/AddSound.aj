/* 
 * Source code by Ana Garcia
 */
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
public aspect AddSound {
	
	 private static final String SOUND_DIR = "/sounds/";
	 private static final String BOARD_HIT_SOUND = "blast.wav";
	 private static final String SHIP_SUNK_SOUND = "siren.wav";
	
	pointcut boardWasHit(): 
		call(void Board.notifyHit(Place,int));
		
	
	after(): boardWasHit(){
		playAudio(BOARD_HIT_SOUND);
	}
	
	pointcut shipWasSunk():
		call(void Board.notifyShipSunk(Ship));
	
	after(): shipWasSunk(){
		playAudio(SHIP_SUNK_SOUND);
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
