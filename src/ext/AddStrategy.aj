package ext;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import battleship.model.Board;
import battleship.model.Ship;
import battleship.model.Place;
import battleship.Constants;
import battleship.*;
import java.util.Random;
import static javax.swing.WindowConstants.DISPOSE_ON_CLOSE;

public privileged aspect AddStrategy {	
	private JButton playButton = new JButton("Play");
    private JPanel newButtons;
    private BoardPanel opponentB;
    private boolean play =false;

	//rename the "Play" button to "Practice
	after(BattleshipDialog dialog): target(dialog) && call(JPanel BattleshipDialog.makeControlPane()){
        dialog.playButton.setText("Practice");
        JPanel buttons = (JPanel) dialog.playButton.getParent();
        newButtons = buttons;
        buttons.add(playButton);
        JComboBox menu = create();
        newButtons.add(menu);
        Board opponent = new Board(10);
        BoardPanel opBoard = new BoardPanel(opponent, 5, 5, 10,
                new Color(51, 153, 255), Color.RED, Color.GRAY);
        opBoard.setPreferredSize(new Dimension(150, 150));

        playButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {

                if (JOptionPane.showConfirmDialog(dialog,
                        "Play a new game?", "Battleship", JOptionPane.YES_NO_OPTION)
                        == JOptionPane.YES_OPTION) {
                    System.out.println("You clicked the Play button!");

                    play = true;
                    dialog.board.reset();
                    opponent.reset();
                    dialog.placeShips();
                    placeShips(opponent);
                    newButtons.add(opBoard);
                    opponentB = opBoard;
                    dialog.setVisible(true);
                    dialog.setDefaultCloseOperation(DISPOSE_ON_CLOSE);




                }
            }
        });
        dialog.playButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                System.out.println("You here bru");
                play = false;
                dialog.board.reset();
                newButtons.remove(opBoard);

            }
        });
    }

    after(BoardPanel cBoard): this(cBoard) && execution(void placeClicked(Place)){
	    if(play){
	        sweep(opponentB);
        }
    }


    private Place rand(BoardPanel opponent){
        Random x = new Random();
        Random y = new Random();

        int xCoor = x.nextInt(10)+1;
        int yCoor = y.nextInt(10)+1;
        Place p = opponent.board.at(xCoor,yCoor);
        while(p.isHit()){
            xCoor = x.nextInt(10)+1;
            yCoor = y.nextInt(10)+1;
            p = opponent.board.at(xCoor,yCoor);
        }
        if(p != null){

            p.hit();
            opponent.repaint();
        }
        return p;

    }
    private Place sweep(BoardPanel opponent){
        int xCoor = 1;
        int yCoor = 1;
        Place p = opponent.board.at(xCoor,yCoor);
        while(p.isHit()) {
            if (xCoor <= 9) {
                xCoor++;
                p = opponent.board.at(xCoor, yCoor);
            } else {
                yCoor++;
                xCoor = 1;
                System.out.println(xCoor + " " + yCoor);
                p = opponent.board.at(xCoor, yCoor);
            }
        }
        if(p != null){

            p.hit();
            opponent.repaint();
        }
        return p;
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