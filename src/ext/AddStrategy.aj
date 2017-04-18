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
    
    private void smartStrategy(BoardPanel opponent){
    	int row = 0;
    	int col = 0;
    	while(!opponent.board.isGameOver()){
    		//max  = 10 (the board size)
    		//min = 1 (the smallest board index)
    		row = (int)(Math.random() * ((10 - 1) + 1)) + 1;
    		col = (int)(Math.random() * ((10 - 1) + 1)) + 1;
    		Place hitSpot = new Place(row,col,opponent.board);
    		//mark this place as hit
    		hitSpot.hit();
    		//if there's a ship at opponentBoard[row][col]
    		if(hitSpot.hasShip()){
    			//get the ship that's on this place & its size
    			Ship targetShip = hitSpot.ship();
    			int shipSize = targetShip.size();
    			if(targetShip.isHorizontal()){
    				//if this place is the ship's head || the tail
    				if((targetShip.head().x == row && targetShip.head().y == col) || 
    						(targetShip.tail().x == row && targetShip.tail().y == col)){
    					//find if targetShip is oriented to the right
    					if(targetShip.places.contains(opponent.board.at(row,col+1)) && (col+1 <= opponent.board.size())){
    						//mark opponentBoard[row][col+1] as hit
    						for(int i=0; i<targetShip.size();i++)
    							opponent.board.at(row,col+1).isHit = true;    							
    					}
    					//the ship is oriented to the left
    					else if (targetShip.places.contains(opponent.board.at(row,col-1)) && (col-1<= opponent.board.size())){
    						for(int i=0; i<targetShip.size();i++)
    							opponent.board.at(row,col-1).isHit = true;
    					}
    					else{//it's neither head, nor tail, it's one of the spots in the middle of the ship
    						//shoot the ship to the right until you get to the end of the right side
    						for(int i=row+1;i<=targetShip.size();i++)
    							opponent.board.at(i,col).isHit = true;
    						//shoot to the left until the ship is sunk
    						int newRow = row -1;
    						while(!targetShip.isSunk()){
    							opponent.board.at(newRow,col).isHit = true;
    							newRow--;
    						}
    					}
    				}
    			}
    			else if(targetShip.isVertical()){
    				//if this place is the ship's head || the tail
    				if((targetShip.head().x == row && targetShip.head().y == col)||
    						(targetShip.tail().x==row && targetShip.tail().y == col)){
    					//find if targetShip is oriented above
    					if(targetShip.places.contains(opponent.board.at(row+1,col)) && (row+1 <= opponent.board.size())){
    						for(int i=0; i<targetShip.size();i++){
    							//mark opponentBoard[row][col+1] as hit
    							opponent.board.at(row+1,col).isHit = true;    							
    						}
    					}
    					//the ship is oriented below
    					else if(targetShip.places.contains(opponent.board.at(row-1,col))&& (row-1<=opponent.board.size())){
    						//mark opponentBoard[row][col+1] as hit
    						for(int i=0; i<targetShip.size();i++)
    							opponent.board.at(row-1,col).isHit = true;    							
    					}
    					//i
    					else{//it's neither head, nor tail, it's one of the spots in the middle of the ship
    						//shoot above the ship until you get to the end of it
    						for(int i=col+1; i <= targetShip.size(); i++)
    							opponent.board.at(row,i).isHit = true;
    						//shoot below the ship until it's sunk
    						int newCol = col-1;
    						while(!targetShip.isSunk()){
    							opponent.board.at(row,newCol).isHit = true;
    							newCol--;
    						}
    					}
    					
    				}    				
    			}
    		}
    	}
    }
	

}