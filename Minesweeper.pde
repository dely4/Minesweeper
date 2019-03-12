

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 10;
int NUM_COLS = 10;
public int bombcounter;
public int correctBombs;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    bombcounter = 0;
    correctBombs = 0;
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < buttons.length; i++){
        for(int j = 0; j < buttons[i].length; j++){
            buttons[i][j] = new MSButton(i,j);
        }
    }    
    bombs = new ArrayList<MSButton>();
    
    setBombs();
}
public void setBombs()
{
    
    while(bombcounter<NUM_ROWS){
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if(!bombs.contains(buttons[row][col])){
            bombs.add(buttons[row][col]);
        }else{
            bombcounter -=1;
        }
        bombcounter+=1;
    }
}

public void draw ()
{
    background( 0 );
    if(correctBombs==bombcounter){
        displayWinningMessage();
    }
}

public void displayLosingMessage()
{
    System.out.println("ur trash, try again");
    setup();
}
public void displayWinningMessage()
{
    
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    public String toString(){
        return(r+ " " + c);
    }
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
            marked = !marked;
            if(marked == false){
                clicked = false;
            }
            if(bombs.contains(this)){
                correctBombs += 1;
            }
        }else if(bombs.contains(this)){
            displayLosingMessage();
        }else if(countBombs(r,c)>0){
            String temp = "" + countBombs(r,c);
            setLabel(temp);
        }else{
            for(int r = -1; r < 2; r++){
                for(int c = -1; c < 2; c++){
                    if(r==0 && c==0){
                        r+=0;
                    }
                    if(isValid(this.r + r, this.c + c)&& !buttons[this.r+r][this.c+c].isClicked()){
                        buttons[this.r+r][this.c+c].mousePressed();
                    }
                }
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0,128,255);
         else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
        if(correctBombs==bombcounter){
            fill(255,255,0);
            setLabel("");
        }
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r>=0 && r < NUM_ROWS && c>=0 && c<NUM_COLS)
            return(true);
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBomb = 0;
        for(int r = -1; r < 2; r++){
            for(int c = -1; c < 2; c++){
                boolean temp;
                if(r==0 && c==0){
                    numBomb+=0;
                }else{
                    if(isValid(row+r,col+c) && bombs.contains(buttons[row+r][col+c])){
                        numBomb+=1;
                    }
                }
            }
        }
        return(numBomb);
    }
}



