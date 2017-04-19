/*
 * Source Code by Jesus Juarez
 * and Ana Garcia
 */
		
package ext;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import battleship.model.Board;
import battleship.model.Ship;
import battleship.model.Place;
import battleship.*;
import java.util.Random;
import static javax.swing.WindowConstants.DISPOSE_ON_CLOSE;


public privileged aspect AddStrategy {
	private JButton playButton = new JButton("Play");
	private JPanel newButtons;
	private BoardPanel opponentB;
	private boolean play = false;
	private String strategy = "Random";
	private final static Dimension def = new Dimension(335,440);
	

	/** rename the "Play" button to "Practice" **/
 after(BattleshipDialog dialog): target(dialog) && call(JPanel BattleshipDialog.makeControlPane()){
		dialog.playButton.setText("Practice");
		JPanel buttons = (JPanel) dialog.playButton.getParent();
		newButtons = buttons;
		buttons.add(playButton);
		Dimension newSize = new Dimension(335,550);
		JComboBox menu = create();
		newButtons.add(menu);
		//Adds your board for computer
		Board opponent = new Board(10);
		BoardPanel opBoard = new BoardPanel(opponent, 5, 5, 10,
				new Color(51, 153, 255), Color.RED, Color.GRAY);
		opBoard.setPreferredSize(new Dimension(150, 150));

		/** Action Listener for Play button **/
		playButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (JOptionPane.showConfirmDialog(dialog,
						"Play a new game?", "Battleship", JOptionPane.YES_NO_OPTION)
						== JOptionPane.YES_OPTION) {
					dialog.resize(newSize);
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

		/** Action Listener for Practice button **/
		dialog.playButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (JOptionPane.showConfirmDialog(dialog,
						"Play a new game?", "Battleship", JOptionPane.YES_NO_OPTION)
						== JOptionPane.YES_OPTION) {

					dialog.resize(def);
					play = false;
					dialog.board.reset();
					newButtons.remove(opBoard);
				}
			}
		});

		/** Action Listener for drop down menu **/
		menu.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				JComboBox combo = (JComboBox)e.getSource();
				String choice = (String)combo.getSelectedItem();
				System.out.println(choice);
				strategy = choice;
			}
		});

	}

	/** Advice to implement chosen strategies **/
	after(BoardPanel cBoard): this(cBoard) && execution(void placeClicked(Place)){
		if(play) {
			if (strategy == "Sweep") {
				sweep(opponentB);
			} else if (strategy == "Smart") {
				smartStrategy(opponentB);
			} else {
				rand(opponentB);
			}
		}

	}

	/** Random Strategy method **/
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

	/** Sweep Strategy method **/
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

	/** Creates drop down menu for strategies **/
	private JComboBox create(){
		String[] strat = {" ", "Random", "Sweep", "Smart"};
		JComboBox<String> ops = new JComboBox<>(strat);
		return ops;
	}

	/** Places player's ships on new board. **/
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
		int row = 1;
		int col = 1;
		//max  = 10 (the board size)
		//min = 1 (the smallest board index)
		Place hitSpot = opponent.board.at(row,col);
		if(opponent.board.at(row,col).isHit){
			row = (int)(Math.random() * ((10 - 1) + 1)) + 1;
			col = (int)(Math.random() * ((10 - 1) + 1)) + 1;
			hitSpot = opponent.board.at(row,col);
		}
		//otherwise mark this place as hit
		hitSpot.hit();
		//repaint the board panel
		opponent.repaint();
		//if there's a ship at opponentBoard[row][col]
		if(hitSpot.hasShip()){
			//get the ship that's on this place
			Ship targetShip = hitSpot.ship();
			if(targetShip.isHorizontal()){
				//if this place is the ship's head || the tail
				if((targetShip.head().x == row && targetShip.head().y == col) ||
						(targetShip.tail().x == row && targetShip.tail().y == col)){
					//find if targetShip is oriented to the right
					if((col+1 <= opponent.board.size()) && targetShip.places.contains(opponent.board.at(row,col+1))){
						//mark opponentBoard[row][col+1] as hit
						opponent.board.at(row,col+1).isHit = true;
						opponent.repaint();
						col++;
					}
					//the ship is oriented to the left
					else if ((col-1<= opponent.board.size()) && targetShip.places.contains(opponent.board.at(row,col-1))){
						opponent.board.at(row,col-1).isHit = true;
						opponent.repaint();
						col--;
					}
					else{//it's neither head, nor tail, it's one of the spots in the middle of the ship
						//shoot the ship to the right until you get to the end of the right side
						if((col+1 <= opponent.board.size()) && targetShip.places.contains(opponent.board.at(row,col+1))){
							opponent.board.at(row,col+1).isHit = true;
							opponent.repaint();
							col++;
						}
						//shoot to the left until the ship is sunk
						if((col-1 <= opponent.board.size() && opponent.board.at(row,col-1).isHit))
							col--; //more to the left of the ship until you find a spot that hasn't been hit
						else if(col-1 <= opponent.board.size() && !opponent.board.at(row,col-1).isHit){
							opponent.board.at(row,col).isHit = true;
							opponent.repaint();
							col--;
						}

					}
				}
			}
			else if(targetShip.isVertical()){
				//if this place is the ship's head || the tail
				if((targetShip.head().x == row && targetShip.head().y == col)||
						(targetShip.tail().x==row && targetShip.tail().y == col)){
					//find if targetShip is oriented below
					if((row+1 <= opponent.board.size()) && targetShip.places.contains(opponent.board.at(row+1,col))){
						//mark opponentBoard[row][col+1] as hit
						opponent.board.at(row+1,col).isHit = true;
						opponent.repaint();
						row++;
					}
					//the ship is oriented above
					else if((row-1<=opponent.board.size()) && targetShip.places.contains(opponent.board.at(row-1,col))){
						//mark opponentBoard[row][col+1] as hit
						opponent.board.at(row-1,col).isHit = true;
						opponent.repaint();
						row--;
					}
					else{//it's neither head, nor tail, it's one of the spots in the middle of the ship
						//shoot above the ship until you get to the end of it
						if((row-1 <= opponent.board.size()) && targetShip.places.contains(opponent.board.at(row-1,col))){
							opponent.board.at(row-1,col).isHit = true;
							opponent.repaint();
							row--;
							hitSpot = opponent.board.at(row, col);
						}
						//shoot below the ship until it is sunk
						if((row+1 <= opponent.board.size() && opponent.board.at(row+1,col).isHit))
							row++; //more to the bottom of the ship until you find a spot that hasn't been hit
						else if(row-1 <= opponent.board.size() && !opponent.board.at(row-1,col).isHit){
							opponent.board.at(row-1,col).isHit = true;
							opponent.repaint();
							row++;
							hitSpot = opponent.board.at(row, col);
						}
					}
				}
			}
		}
	}
}