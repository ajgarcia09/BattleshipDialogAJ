package ext;
import javax.swing.JButton;
import javax.swing.JPanel;
import java.awt.event.ActionListener;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.event.ActionEvent;
import battleship.model.Board;
import battleship.Constants;
import battleship.*;

/*  public BoardPanel(Board board,
            int topMargin, int leftMargin, int placeSize,
            Color boardColor, Color hitColor, Color missColor)
            */

public privileged aspect AddStrategy {
	private JButton playButton = new JButton("Play");
	
	
	//rename the "Play" button to "Practice
	after(BattleshipDialog dialog): this(dialog)
		&& execution(JPanel BattleshipDialog.makeControlPane()){
		dialog.playButton.setText("Practice");
		JPanel buttons = (JPanel) dialog.playButton.getParent();
		buttons.add(playButton);
		//add an event handler for the new playButton
		playButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				System.out.println("You clicked the Play button!");
				//(width, height)
				//comment these and #1 and #2 will work! :D
				dialog.setSize(700, 450);
				BoardPanel playerBoard = new BoardPanel(new Board(10),Constants.DEFAULT_TOP_MARGIN,350, 
						Constants.DEFAULT_PLACE_SIZE, Constants.DEFAULT_BOARD_COLOR,
						Constants.DEFAULT_HIT_COLOR,Constants.DEFAULT_MISS_COLOR);
				dialog.add(playerBoard);
			}
});
	}
	

}
