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
				/*I originally created a new JPanel and added the BoardPanel to the 
				 * JPanel and then tried adding the JPanel to dialog (a BattleshipDialog obj)
				 * Since it didn't work, I tried just adding a new BoardPanel directly to the 
				 * dialog, but it doesn't show.
				 * I set the background to magenta just to see if anything at all was being 
				 * addeed to the dialog 
				 */
				System.out.println("You clicked the Play button!");
				dialog.setSize(335,600);
				//JPanel newPanel = new JPanel(new BorderLayout());
				//newPanel.setBackground(Color.MAGENTA);
				dialog.add(new BoardPanel(new Board(10),0,0,10,Constants.DEFAULT_BOARD_COLOR,
					Constants.DEFAULT_HIT_COLOR,Constants.DEFAULT_MISS_COLOR),BorderLayout.NORTH);
				//dialog.add(newPanel);
				//newPanel.setVisible(true);

			}
});
	}
	/*this code snippet adds a new BoardPanel as soon as the program is run
	 * (it doesn't wait for the play button to be clicked)
	 * It only shows a portion of the new BoardPanel (topmost row)
	 */
//		pointcut addBoard(BattleshipDialog newDialog):
//			execution(JPanel makeBoardPane()) && this(newDialog);
//
//		JPanel around(BattleshipDialog newDialog) : addBoard(newDialog){
//			JPanel newPanel = new JPanel(new BorderLayout());
//			newPanel.add(new BoardPanel(newDialog.board,0,0,10,Constants.DEFAULT_BOARD_COLOR,
//					Constants.DEFAULT_HIT_COLOR,Constants.DEFAULT_MISS_COLOR),BorderLayout.NORTH);
//			newPanel.add(proceed(newDialog),BorderLayout.CENTER);
//			return newPanel;
//		
//	}
	

}