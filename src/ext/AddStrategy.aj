package ext;
import javax.swing.JButton;
import javax.swing.JPanel;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;


import battleship.*;

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
				BattleshipDialog dialog = new BattleshipDialog();
		        dialog.setVisible(true);
		        //dialog.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
			}
});
	}
	

}
