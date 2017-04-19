/**
 /* Shows the enemy ships when F5 is pressed.
 * @author Jesus Juarez
 *
 **/

package ext;

import battleship.BoardPanel;
import battleship.model.Place;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import javax.swing.AbstractAction;
import javax.swing.ActionMap;
import javax.swing.InputMap;
import javax.swing.JComponent;
import javax.swing.KeyStroke;

public privileged aspect AddCheatKey {
    private static boolean key = false;

    pointcut getBoard(BoardPanel board): execution(BoardPanel.new(..)) && this(board);
    after(BoardPanel board): getBoard(board){
        ActionMap actionMap = board.getActionMap();
        int condition = JComponent.WHEN_IN_FOCUSED_WINDOW;
        InputMap inputMap = board.getInputMap(condition);
        String cheat = "Cheat";
        inputMap.put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0), cheat);
        actionMap.put(cheat, new KeyAction(board, cheat));
    }

    pointcut reveal(BoardPanel bPanel, Graphics g):  execution(void BoardPanel.paint(Graphics)) && args(g) && this(bPanel);
    after(BoardPanel bPanel, Graphics g): reveal(bPanel, g){
        if(key) {
            enable(g,bPanel);
        }
    }
    private static class KeyAction extends AbstractAction {
        private final BoardPanel boardPanel;

        public KeyAction(BoardPanel boardPanel, String command) {
            this.boardPanel = boardPanel;
            putValue(ACTION_COMMAND_KEY, command);
        }

        /** Called when a cheat is requested. */
        public void actionPerformed(ActionEvent event) {
            if(!key){
                key = true;
                System.out.println("Cheat Enabled");
            }
            else {
                key = false;
                System.out.println("Cheat Disabled");
            }
            boardPanel.repaint();
        }
    }

    private static void enable(Graphics g,BoardPanel bPanel){
        for(Place p: bPanel.board.places()){
            if(p.hasShip()){
                int x = bPanel.leftMargin + (p.getX() - 1) * bPanel.placeSize;
                int y = bPanel.topMargin + (p.getY() - 1) * bPanel.placeSize;
                g.setColor(Color.GREEN);
                g.drawLine(x + 1, y + 1,
                        x + bPanel.placeSize - 1, y + bPanel.placeSize - 1);
                g.drawLine(x + 1, y + bPanel.placeSize - 1,
                        x + bPanel.placeSize - 1, y + 1);

            }
        }
    }

}
