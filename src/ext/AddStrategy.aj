package ext;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import battleship.model.Board;
import battleship.model.Ship;
import battleship.Constants;
import battleship.*;
import java.util.Random;
import static javax.swing.WindowConstants.DISPOSE_ON_CLOSE;

public privileged aspect AddStrategy {	
	private JButton playButton = new JButton("Play");
    private JPanel newButtons;
    private BattleshipDialog oDialog;

	//rename the "Play" button to "Practice
	after(BattleshipDialog dialog): target(dialog) && call(JPanel BattleshipDialog.makeControlPane()){
        dialog.playButton.setText("Practice");
        JPanel buttons = (JPanel) dialog.playButton.getParent();
        newButtons = buttons;
        buttons.add(playButton);
        playButton.addActionListener(this:: play);
        oDialog = dialog;


    }

    private void play(ActionEvent event){
        BattleshipDialog op = new BattleshipDialog(new Dimension(335,580));

        if (JOptionPane.showConfirmDialog(op,
                "Play a new game?", "Battleship", JOptionPane.YES_NO_OPTION)
                == JOptionPane.YES_OPTION) {
            Board opponent = new Board(10);
            placeShips(opponent);

            BoardPanel opBoard = new BoardPanel(opponent,5,5,10,
                    new Color(51,153,255), Color.RED, Color.GRAY);

            JComboBox menu = create();
            opBoard.setPreferredSize(new Dimension(150,150));


            newButtons.add(menu);
            newButtons.add(opBoard);

            op.setVisible(true);
            op.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
            //oDialog.dispose();




            //oDialog.dispose();
        }

    }
    private JComboBox create(){
        String[] strat = {"", "sweep", "smart"};
        JComboBox<String> ops = new JComboBox<>(strat);
        return ops;
    }
    private void placeShips(Board board){
        Random random = new Random();
        int size = board.size();
        for (Ship ship : board.ships()) {
            int i = 0;
            int j = 0;
            boolean dir = false;
            do {
                i = random.nextInt(size) + 1;
                j = random.nextInt(size) + 1;
                dir = random.nextBoolean();
            } while (!board.placeShip(ship, i, j, dir));
        }

    }
	

}