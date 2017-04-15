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
			
			}
});
	}
		pointcut addBoard(BattleshipDialog newDialog):
			execution(JPanel makeBoardPane()) && this(newDialog);

		JPanel around(BattleshipDialog newDialog) : addBoard(newDialog){
			JPanel newPanel = new JPanel(new BorderLayout());
			newPanel.add(new BoardPanel(newDialog.board,0,0,10,Constants.DEFAULT_BOARD_COLOR,
					Constants.DEFAULT_HIT_COLOR,Constants.DEFAULT_MISS_COLOR),BorderLayout.NORTH);
			newPanel.add(proceed(newDialog),BorderLayout.CENTER);
			return newPanel;
		
	}
	

}