
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;
use work.SQUARE.all;
use IEEE.NUMERIC_STD.ALL;
use work.SQUARE2.all;
use work.SQUARE3.all;

entity VGA is
    Port ( CLK25              : IN  STD_LOGIC;																			
           rez_160x120        : IN  STD_LOGIC;
           rez_320x240        : IN  STD_LOGIC;
           Hsync,Vsync        : OUT STD_LOGIC;						
			  Nblank             : OUT STD_LOGIC;								
           activecam_o        : OUT STD_LOGIC;
			  reset              : IN  STD_LOGIC;
			  ledOut_P : out std_logic_vector(6 downto 0) := "0000000";
			  ledOut_C : out std_logic_vector(6 downto 0) := "0000000";
			  KEYS: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			  S: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		     R,G,B 	            : OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
			  Nsync              : OUT STD_LOGIC);	
end VGA;

architecture Behavioral of VGA is
signal Hcnt:STD_LOGIC_VECTOR(9 downto 0):="0000000000";		
signal Vcnt:STD_LOGIC_VECTOR(9 downto 0):="1000001000";		
signal video:STD_LOGIC;
constant HM: integer :=799;	
constant HD: integer :=640;	
constant HF: integer :=16;		
constant HB: integer :=48;		
constant HR: integer :=96;		
constant VM: integer :=524;	
constant VD: integer :=480;	
constant VF: integer :=10;		
constant VB: integer :=33;		
constant VR: integer :=2;		
signal counter :integer  range 0 to 200_000_000 :=0;
signal co :integer:=0;
signal ball_row: integer := 240; -- 480/2
signal ball_col: integer := 320; -- 640/2
signal ball_size : integer := 5;
type sinlut is array (0 to 359) of integer;--
signal sinrom : sinlut;
signal cosrom : sinlut;
------------------------------------------square----------
SIGNAL RGB: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL DRAW1,DRAW2,DRAW3,DRAW4,DRAW5,DRAW6,DRAW7,DRAW8,DRAW9,DRAW10,DRAW11,DRAW12, DRAW13,DRAW14,DRAW15,DRAW16,DRAW17,DRAW18 ,DRAW19,DRAW20,DRAW21,DRAW22,DRAW23,DRAW24,DRAW25,DRAW26,DRAW27,DRAW28, DRAW29,DRAW30,DRAW31,DRAW32,DRAW33,DRAW34 : STD_LOGIC;
SIGNAL DRAW_1,DRAW_2,DRAW_3,DRAW_4,DRAW_5,DRAW_6,DRAW_7,DRAW_8,DRAW_9,DRAW_10,DRAW_11,DRAW_12,DRAW_13,DRAW_14,DRAW_15,DRAW_16 : STD_LOGIC;
SIGNAL DRAW_1U,DRAW_2U,DRAW_3U,DRAW_4U,DRAW_5U,DRAW_6U,DRAW_7U,DRAW_8U,DRAW_9U,DRAW_10U,DRAW_11U,DRAW_12U,DRAW_13U,DRAW_14U,DRAW_15U,DRAW_16U : STD_LOGIC;
SIGNAL SQ_X1,SQ_Y1: integer range 0 to 1688:=125;
SIGNAL SQ_X2,SQ_Y2: integer range 0 to 1688:=1000;
SIGNAL SQ_X3,SQ_Y3: integer range 0 to 1688:=480;
SIGNAL SQ_X4,SQ_Y4, SQ_X5,SQ_Y5, SQ_X6,SQ_Y6, SQ_X7,SQ_Y7, SQ_X8,SQ_Y8, SQ_X9,SQ_Y9, SQ_X10,SQ_Y10, SQ_X11,SQ_Y11, SQ_X12,SQ_Y12, SQ_X13,SQ_Y13, SQ_X14,SQ_Y14, SQ_X15,SQ_Y15, SQ_X16,SQ_Y16, SQ_X17,SQ_Y17, SQ_X18,SQ_Y18 : integer range 0 to 1688:=480;
SIGNAL SQ_X19,SQ_Y19, SQ_X20,SQ_Y20, SQ_X21,SQ_Y21, SQ_X22,SQ_Y22, SQ_X23,SQ_Y23, SQ_X24,SQ_Y24, SQ_X25,SQ_Y25, SQ_X26,SQ_Y26, SQ_X27,SQ_Y27, SQ_X28,SQ_Y28, SQ_X29,SQ_Y29, SQ_X30,SQ_Y30, SQ_X31,SQ_Y31, SQ_X32,SQ_Y32, SQ_X33,SQ_Y33, SQ_X34,SQ_Y34 : integer range 0 to 1688:=480;
SIGNAL SQ1_X19, SQ1_Y19, SQ1_X20,SQ1_Y20: integer range 0 to 1688:=480;
SIGNAL SQ3_X19,SQ3_Y19, SQ3_X20,SQ3_Y20, SQ3_X21,SQ3_Y21, SQ3_X22,SQ3_Y22, SQ3_X23,SQ3_Y23, SQ3_X24,SQ3_Y24, SQ3_X25,SQ3_Y25, SQ3_X26,SQ3_Y26, SQ3_X27,SQ3_Y27, SQ3_X28,SQ3_Y28, SQ3_X29,SQ3_Y29, SQ3_X30,SQ3_Y30, SQ3_X31,SQ3_Y31, SQ3_X32,SQ3_Y32, SQ3_X33,SQ3_Y33, SQ3_X34,SQ3_Y34 : integer range 0 to 1688:=480;
SIGNAL SQ4_X3, SQ4_Y3,SQ4_X4,SQ4_Y4, SQ4_X5,SQ4_Y5, SQ4_X6,SQ4_Y6, SQ4_X7,SQ4_Y7, SQ4_X8,SQ4_Y8, SQ4_X9,SQ4_Y9, SQ4_X10,SQ4_Y10, SQ4_X11,SQ4_Y11, SQ4_X12,SQ4_Y12, SQ4_X13,SQ4_Y13, SQ4_X14,SQ4_Y14, SQ4_X15,SQ4_Y15, SQ4_X16,SQ4_Y16, SQ4_X17,SQ4_Y17, SQ4_X18,SQ4_Y18 : integer range 0 to 1688:=480;
signal pixel_column_W : std_logic_vector(9 downto 0);
signal pixel_row_W    : std_logic_vector(9 downto 0);
signal HSYNC_W,VSYNC_W: STD_LOGIC;
SIGNAL X_W,Y_W: INTEGER range 0 to 1688;
signal L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12, L13, L14, L15, L16 : STD_LOGIC := '0';
signal R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, R16 : STD_LOGIC := '0';
SIGNAL SW5, SW4, SW3, SW2, SW1, SW0: STD_LOGIC:= '0';
SIGNAL RC: integer range 0 to 1688:=40;
SIGNAL counter2: integer range 0 to 1688 :=0;
SIGNAL B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16: STD_LOGIC:= '0';
SIGNAL C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16: INTEGER RANGE 0 TO 1688 :=0;
SIGNAL G1,G2,G3,G4,G5,G6,G7,G8,G9,G10,G11,G12,G13,G14,G15,G16: STD_LOGIC:= '0';
SIGNAL B1_W,B2_W,B3_w,B4_w,B5_w,B6_w,B7_w,B8_w,B9_w,B10_w,B11_w,B12_w,B13_w,B14_w,B15_w,B16_w: STD_LOGIC:= '0';
SIGNAL G1_W,G2_W,G3_w,G4_w,G5_w,G6_w,G7_w,G8_w,G9_w,G10_w,G11_w,G12_w,G13_w,G14_w,G15_w,G16_w: STD_LOGIC:= '0';
SIGNAL SPCX,SPCY: INTEGER RANGE 0 TO 1688;
SIGNAL counter_L: INTEGER RANGE 0 TO 1688 :=0;
SIGNAL reset_W: STD_LOGIC:= '0';
SIGNAL counter_W: INTEGER RANGE 0 TO 1688:= 0;
SIGNAL counter_P: INTEGER RANGE 0 TO 1688:= 0;
SIGNAL counter_P2: INTEGER RANGE 0 TO 1688:= 0;
------------------Scorboard------------
signal show_C: std_logic_vector(3 downto 0);
signal show_P: std_logic_vector(3 downto 0);
signal LEDs: std_logic_vector(6 downto 0);
------------------------------------------


signal pixel_row     : std_logic_vector(9 downto 0);
signal pixel_column : std_logic_vector(9 downto 0);
-------clock divider-----------------------------
signal slow_clk : STD_LOGIC;
SIGNAL SLOWER_CLK: STD_LOGIC;

    component Clock_Divider
        Port ( 
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            clock_out: out STD_LOGIC
        );
    end component;
	 
	 	COMPONENT Clock_DividerXL is
    port ( 
        clk      : in  std_logic;
        reset    : in  std_logic;
        clock_out: out std_logic
    );
end component;
---------------------------------------



begin

U1: Clock_Divider port map (clk => CLK25, reset => '0', clock_out => slow_clk);
U2: Clock_DividerXL PORT MAP (clk => CLK25, reset => reset_W, clock_out => SLOWER_CLK);

---------------------------------
reset_W <= reset;
SW5 <= KEYS(5);
SW4 <= KEYS(4);
SW3 <= KEYS(9);
SW2 <= KEYS(8);
SW1 <= KEYS(7);
SW0 <= KEYS(6);
X_W <= 100;
Y_W <= 210;
RC  <= 40;
SPCX<= 2;
SPCY<= 2;
-------------Score connection-------------
show_C <= STD_LOGIC_VECTOR(to_unsigned(counter_P2, 4));
show_P <= STD_LOGIC_VECTOR(to_unsigned(counter_W, 4));
-----------------------------player------------
SQ_X3 <= X_W;
SQ_Y3 <= Y_W;
SQ_X4 <= X_W + 40;
SQ_Y4 <= Y_W;
SQ_X5 <= X_W + 80;
SQ_Y5 <= Y_W;
SQ_X6 <= X_W + 120;
SQ_Y6 <= Y_W;
SQ_X7 <= X_W;
SQ_Y7 <= Y_W + 40;
SQ_X8 <= X_W + 40;
SQ_Y8 <= Y_W + 40;
SQ_X9 <= X_W + 80;
SQ_Y9 <= Y_W + 40;
SQ_X10 <= X_W + 120;
SQ_Y10 <= Y_W + 40;
SQ_X11 <= X_W;
SQ_Y11 <= Y_W + 80;
SQ_X12 <= X_W + 40;
SQ_Y12 <= Y_W + 80;
SQ_X13 <= X_W + 80;
SQ_Y13 <= Y_W + 80;
SQ_X14 <= X_W + 120;
SQ_Y14 <= Y_W + 80;
SQ_X15 <= X_W;
SQ_Y15 <= Y_W + 120;
SQ_X16 <= X_W + 40;
SQ_Y16 <= Y_W + 120;
SQ_X17 <= X_W + 80;
SQ_Y17 <= Y_W + 120;
SQ_X18 <= X_W + 120;
SQ_Y18 <= Y_W + 120;
--------------------------computer------------
SQ_X19 <= X_W + 300;
SQ_Y19 <= Y_W;
SQ_X20 <= X_W + 340;
SQ_Y20 <= Y_W;
SQ_X21 <= X_W + 380;
SQ_Y21 <= Y_W;
SQ_X22 <= X_W + 420;
SQ_Y22 <= Y_W;
SQ_X23 <= X_W + 300;
SQ_Y23 <= Y_W + 40;
SQ_X24 <= X_W + 340;
SQ_Y24 <= Y_W + 40;
SQ_X25 <= X_W + 380;
SQ_Y25 <= Y_W + 40;
SQ_X26 <= X_W + 420;
SQ_Y26 <= Y_W + 40;
SQ_X27 <= X_W + 300;
SQ_Y27 <= Y_W + 80;
SQ_X28 <= X_W + 340;
SQ_Y28 <= Y_W + 80;
SQ_X29 <= X_W + 380;
SQ_Y29 <= Y_W + 80;
SQ_X30 <= X_W + 420;
SQ_Y30 <= Y_W + 80;
SQ_X31 <= X_W + 300;
SQ_Y31 <= Y_W + 120;
SQ_X32 <= X_W + 340;
SQ_Y32 <= Y_W + 120;
SQ_X33 <= X_W + 380;
SQ_Y33 <= Y_W + 120;
SQ_X34 <= X_W + 420;
SQ_Y34 <= Y_W + 120;
--------------------------------- SQUARE OF CORRECT OR NOT----------------------------------------
SQ3_X19 <= SQ_X19 + SPCX;
SQ3_Y19 <= SQ_Y19 + SPCY;
SQ3_X20 <= SQ_X20 + SPCX;
SQ3_Y20 <= SQ_Y20 + SPCY;
SQ3_X21 <= SQ_X21 + SPCX;
SQ3_Y21 <= SQ_Y21 + SPCY;
SQ3_X22 <= SQ_X22 + SPCX;
SQ3_Y22 <= SQ_Y22 + SPCY;
SQ3_X23 <= SQ_X23 + SPCX;
SQ3_Y23 <= SQ_Y23 + SPCY;
SQ3_X24 <= SQ_X24 + SPCX;
SQ3_Y24 <= SQ_Y24 + SPCY;
SQ3_X25 <= SQ_X25 + SPCX;
SQ3_Y25 <= SQ_Y25 + SPCY;
SQ3_X26 <= SQ_X26 + SPCX;
SQ3_Y26 <= SQ_Y26 + SPCY;
SQ3_X27 <= SQ_X27 + SPCX;
SQ3_Y27 <= SQ_Y27 + SPCY;
SQ3_X28 <= SQ_X28 + SPCX;
SQ3_Y28 <= SQ_Y28 + SPCY;
SQ3_X29 <= SQ_X29 + SPCX;
SQ3_Y29 <= SQ_Y29 + SPCY;
SQ3_X30 <= SQ_X30 + SPCX;
SQ3_Y30 <= SQ_Y30 + SPCY;
SQ3_X31 <= SQ_X31 + SPCX;
SQ3_Y31 <= SQ_Y31 + SPCY;
SQ3_X32 <= SQ_X32 + SPCX;
SQ3_Y32 <= SQ_Y32 + SPCY;
SQ3_X33 <= SQ_X33 + SPCX;
SQ3_Y33 <= SQ_Y33 + SPCY;
SQ3_X34 <= SQ_X34 + SPCX;
SQ3_Y34 <= SQ_Y34 + SPCY;
--------------------------------for choice
SQ4_X3 <= SQ_X3 + SPCX;
SQ4_Y3 <= SQ_Y3 + SPCY;
SQ4_X4 <= SQ_X4 + SPCX;
SQ4_Y4 <= SQ_Y4 + SPCY;
SQ4_X5 <= SQ_X5 + SPCX;
SQ4_Y5 <= SQ_Y5 + SPCY;
SQ4_X6 <= SQ_X6 + SPCX;
SQ4_Y6 <= SQ_Y6 + SPCY;
SQ4_X7 <= SQ_X7 + SPCX;
SQ4_Y7 <= SQ_Y7 + SPCY;
SQ4_X8 <= SQ_X8 + SPCX;
SQ4_Y8 <= SQ_Y8 + SPCY;
SQ4_X9 <= SQ_X9 + SPCX;
SQ4_Y9 <= SQ_Y9 + SPCY;
SQ4_X10 <= SQ_X10 + SPCX;
SQ4_Y10 <= SQ_Y10 + SPCY;
SQ4_X11 <= SQ_X11 + SPCX;
SQ4_Y11 <= SQ_Y11 + SPCY;
SQ4_X12 <= SQ_X12 + SPCX;
SQ4_Y12 <= SQ_Y12 + SPCY;
SQ4_X13 <= SQ_X13 + SPCX;
SQ4_Y13 <= SQ_Y13 + SPCY;
SQ4_X14 <= SQ_X14 + SPCX;
SQ4_Y14 <= SQ_Y14 + SPCY;
SQ4_X15 <= SQ_X15 + SPCX;
SQ4_Y15 <= SQ_Y15 + SPCY;
SQ4_X16 <= SQ_X16 + SPCX;
SQ4_Y16 <= SQ_Y16 + SPCY;
SQ4_X17 <= SQ_X17 + SPCX;
SQ4_Y17 <= SQ_Y17 + SPCY;
SQ4_X18 <= SQ_X18 + SPCX;
SQ4_Y18 <= SQ_Y18 + SPCY;




--Hcnt <=std_logic_vector(to_unsigned(9, 10));
--Hsync <= HSYNC_W;
--Vsync <= VSYNC_W;
SQ(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X1,
    SQ_Y1,
    RGB,
    DRAW1
);
SQ(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X2,
    SQ_Y2,
    RGB,
    DRAW2
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X3,
    SQ_Y3,
    RGB,
    DRAW3
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X4,
    SQ_Y4,
    RGB,
    DRAW4
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X5,
    SQ_Y5,
    RGB,
    DRAW5
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X6,
    SQ_Y6,
    RGB,
    DRAW6
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X7,
    SQ_Y7,
    RGB,
    DRAW7
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X8,
    SQ_Y8,
    RGB,
    DRAW8
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X9,
    SQ_Y9,
    RGB,
    DRAW9
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X10,
    SQ_Y10,
    RGB,
    DRAW10
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X11,
    SQ_Y11,
    RGB,
    DRAW11
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X12,
    SQ_Y12,
    RGB,
    DRAW12
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X13,
    SQ_Y13,
    RGB,
    DRAW13
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X14,
    SQ_Y14,
    RGB,
    DRAW14
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X15,
    SQ_Y15,
    RGB,
    DRAW15
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X16,
    SQ_Y16,
    RGB,
    DRAW16
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X17,
    SQ_Y17,
    RGB,
    DRAW17
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X18,
    SQ_Y18,
    RGB,
    DRAW18
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X19,
    SQ_Y19,
    RGB,
    DRAW19
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X20,
    SQ_Y20,
    RGB,
    DRAW20
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X21,
    SQ_Y21,
    RGB,
    DRAW21
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X22,
    SQ_Y22,
    RGB,
    DRAW22
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X23,
    SQ_Y23,
    RGB,
    DRAW23
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X24,
    SQ_Y24,
    RGB,
    DRAW24
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X25,
    SQ_Y25,
    RGB,
    DRAW25
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X26,
    SQ_Y26,
    RGB,
    DRAW26
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X27,
    SQ_Y27,
    RGB,
    DRAW27
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X28,
    SQ_Y28,
    RGB,
    DRAW28
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X29,
    SQ_Y29,
    RGB,
    DRAW29
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X30,
    SQ_Y30,
    RGB,
    DRAW30
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X31,
    SQ_Y31,
    RGB,
    DRAW31
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X32,
    SQ_Y32,
    RGB,
    DRAW32
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X33,
    SQ_Y33,
    RGB,
    DRAW33
);
SQ2(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ_X34,
    SQ_Y34,
    RGB,
    DRAW34
);
-------------------------------------------------------------- Finding and correction---------------------------------
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X19,
    SQ3_Y19,
    RGB,
    DRAW_1
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X20,
    SQ3_Y20,
    RGB,
    DRAW_2
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X21,
    SQ3_Y21,
    RGB,
    DRAW_3
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X22,
    SQ3_Y22,
    RGB,
    DRAW_4
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X23,
    SQ3_Y23,
    RGB,
    DRAW_5
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X24,
    SQ3_Y24,
    RGB,
    DRAW_6
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X25,
    SQ3_Y25,
    RGB,
    DRAW_7
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X26,
    SQ3_Y26,
    RGB,
    DRAW_8
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X27,
    SQ3_Y27,
    RGB,
    DRAW_9
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X28,
    SQ3_Y28,
    RGB,
    DRAW_10
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X29,
    SQ3_Y29,
    RGB,
    DRAW_11
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X30,
    SQ3_Y30,
    RGB,
    DRAW_12
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X31,
    SQ3_Y31,
    RGB,
    DRAW_13
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X32,
    SQ3_Y32,
    RGB,
    DRAW_14
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X33,
    SQ3_Y33,
    RGB,
    DRAW_15
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ3_X34,
    SQ3_Y34,
    RGB,
    DRAW_16
);
---------------------------------------------------------------Ship Choosing--------------------------------------------------
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X3,
    SQ4_Y3,
    RGB,
    DRAW_1U
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X4,
    SQ4_Y4,
    RGB,
    DRAW_2U
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X5,
    SQ4_Y5,
    RGB,
    DRAW_3U
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X6,
    SQ4_Y6,
    RGB,
    DRAW_4U
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X7,
    SQ4_Y7,
    RGB,
    DRAW_5U
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X8,
    SQ4_Y8,
    RGB,
    DRAW_6U
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X9,
    SQ4_Y9,
    RGB,
    DRAW_7U
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X10,
    SQ4_Y10,
    RGB,
    DRAW_8U
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X11,
    SQ4_Y11,
    RGB,
    DRAW_9U
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X12,
    SQ4_Y12,
    RGB,
    DRAW_10U
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X13,
    SQ4_Y13,
    RGB,
    DRAW_11U
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X14,
    SQ4_Y14,
    RGB,
    DRAW_12U
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X15,
    SQ4_Y15,
    RGB,
    DRAW_13U
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X16,
    SQ4_Y16,
    RGB,
    DRAW_14U
);
SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X17,
    SQ4_Y17,
    RGB,
    DRAW_15U
);

SQ3(
    to_integer(unsigned(pixel_column)),
    to_integer(unsigned(pixel_row)),
    SQ4_X18,
    SQ4_Y18,
    RGB,
    DRAW_16U
);


genrom_sin: for i in 0 to 359 generate
constant x : real := sin ( real(i) * math_pi / real(179));
constant xn : integer := (integer (x * real(100)));
begin
	sinrom(i) <= xn;
end generate;
	
genrom_cos: for i in 0 to 359 generate
constant x : real := cos ( real(i) * math_pi / real(179));
constant xn : integer := (integer (x * real(100)));
begin
	cosrom(i) <= xn;
end generate;




-------------------------------------------------------------------------------------------------
pixel_column <= Hcnt;
pixel_row    <= Vcnt;
---------------slow clock
process(slow_clk)
    begin
        if rising_edge(slow_clk) then
            if S(0) = '1' then
                if KEYS(0) = '0' then
                    SQ_X1 <= SQ_X1 + 1;
                end if;
                if KEYS(3) = '0' then
                    SQ_X1 <= SQ_X1 - 1;
                end if;
                if KEYS(2) = '0' then
                    SQ_Y1 <= SQ_Y1 - 1;
                end if;
                if KEYS(1) = '0' then
                    SQ_Y1 <= SQ_Y1 + 1;
                end if;
            end if;

            if S(1) = '1' then
                if KEYS(0) = '0' then
                    SQ_X2 <= SQ_X2 + 1;
                end if;
                if KEYS(1) = '0' then
                    SQ_X2 <= SQ_X2 - 1;
                end if;
                if KEYS(2) = '0' then
                    SQ_Y2 <= SQ_Y2 - 1;
                end if;
                if KEYS(3) = '0' then
                    SQ_Y2 <= SQ_Y2 + 1;
                end if;
            end if;
				if (SW5 = '1') then
				  if (SQ_X3 < SQ_X1 and SQ_X1 < SQ_X3+RC and SQ_Y3 < SQ_Y1 and SQ_Y1 < SQ_Y3+RC) then
						L1 <= '1';
				  elsif (SQ_X4 < SQ_X1 and SQ_X1 < SQ_X4+RC and SQ_Y4 < SQ_Y1 and SQ_Y1 < SQ_Y4+RC) then
						L2 <= '1';
				  elsif (SQ_X5 < SQ_X1 and SQ_X1 < SQ_X5+RC and SQ_Y5 < SQ_Y1 and SQ_Y1 < SQ_Y5+RC) then
						L3 <= '1';
				  elsif (SQ_X6 < SQ_X1 and SQ_X1 < SQ_X6+RC and SQ_Y6 < SQ_Y1 and SQ_Y1 < SQ_Y6+RC) then
						L4 <= '1';
				  elsif (SQ_X7 < SQ_X1 and SQ_X1 < SQ_X7+RC and SQ_Y7 < SQ_Y1 and SQ_Y1 < SQ_Y7+RC) then
						L5 <= '1';
				  elsif (SQ_X8 < SQ_X1 and SQ_X1 < SQ_X8+RC and SQ_Y8 < SQ_Y1 and SQ_Y1 < SQ_Y8+RC) then
						L6 <= '1';
				  elsif (SQ_X9 < SQ_X1 and SQ_X1 < SQ_X9+RC and SQ_Y9 < SQ_Y1 and SQ_Y1 < SQ_Y9+RC) then
						L7 <= '1';
				  elsif (SQ_X10 < SQ_X1 and SQ_X1 < SQ_X10+RC and SQ_Y10 < SQ_Y1 and SQ_Y1 < SQ_Y10+RC) then
						L8 <= '1';
				  elsif (SQ_X11 < SQ_X1 and SQ_X1 < SQ_X11+RC and SQ_Y11 < SQ_Y1 and SQ_Y1 < SQ_Y11+RC) then
						L9 <= '1';
				  elsif (SQ_X12 < SQ_X1 and SQ_X1 < SQ_X12+RC and SQ_Y12 < SQ_Y1 and SQ_Y1 < SQ_Y12+RC) then
						L10 <= '1';
				  elsif (SQ_X13 < SQ_X1 and SQ_X1 < SQ_X13+RC and SQ_Y13 < SQ_Y1 and SQ_Y1 < SQ_Y13+RC) then
						L11 <= '1';
				  elsif (SQ_X14 < SQ_X1 and SQ_X1 < SQ_X14+RC and SQ_Y14 < SQ_Y1 and SQ_Y1 < SQ_Y14+RC) then
						L12 <= '1';
				  elsif (SQ_X15 < SQ_X1 and SQ_X1 < SQ_X15+RC and SQ_Y15 < SQ_Y1 and SQ_Y1 < SQ_Y15+RC) then
						L13 <= '1';
				  elsif (SQ_X16 < SQ_X1 and SQ_X1 < SQ_X16+RC and SQ_Y16 < SQ_Y1 and SQ_Y1 < SQ_Y16+RC) then
						L14 <= '1';
				  elsif (SQ_X17 < SQ_X1 and SQ_X1 < SQ_X17+RC and SQ_Y17 < SQ_Y1 and SQ_Y1 < SQ_Y17+RC) then
						L15 <= '1';
				  elsif (SQ_X18 < SQ_X1 and SQ_X1 < SQ_X18+RC and SQ_Y18 < SQ_Y1 and SQ_Y1 < SQ_Y18+RC) then
						L16 <= '1';
				  end if;
			   end if;
----------------------------- Shooting the ship--------------------------
				 if (SW4 = '1') then
					  if (SQ_X19 < SQ_X1 and SQ_X1 < SQ_X19 + RC and SQ_Y19 < SQ_Y1 and SQ_Y1 < SQ_Y19 + RC) then
							if (R1 = '1') then
								 counter2 <= counter2 + 1;
								 B1 <= '1';
								 C1 <= 1;
							else
								 B1_W <= '1';
							end if;
					  elsif (SQ_X20 < SQ_X1 and SQ_X1 < SQ_X20 + RC and SQ_Y20 < SQ_Y1 and SQ_Y1 < SQ_Y20 + RC) then
							if (R2 = '1') then
								 counter2 <= counter2 + 1;
								 B2 <= '1';
								 C2 <= 1;
							else
								 B2_W <= '1';
							end if;
					  elsif (SQ_X21 < SQ_X1 and SQ_X1 < SQ_X21 + RC and SQ_Y21 < SQ_Y1 and SQ_Y1 < SQ_Y21 + RC) then
							if (R3 = '1') then
								 counter2 <= counter2 + 1;
								 B3 <= '1';
								 C3 <= 1;
							else
								 B3_W <= '1';
							end if;							
					  elsif (SQ_X22 < SQ_X1 and SQ_X1 < SQ_X22 + RC and SQ_Y22 < SQ_Y1 and SQ_Y1 < SQ_Y22 + RC) then
							if (R4 = '1') then
								 counter2 <= counter2 + 1;
								 B4 <= '1';
								 C4 <= 1;
							else
								 B4_W <= '1';
							end if;							
					  elsif (SQ_X23 < SQ_X1 and SQ_X1 < SQ_X23 + RC and SQ_Y23 < SQ_Y1 and SQ_Y1 < SQ_Y23 + RC) then
							if (R5 = '1') then
								 counter2 <= counter2 + 1;
								 B5 <= '1';
								 C5 <= 1;
							else
								 B5_W <= '1';
							end if;							
					  elsif (SQ_X24 < SQ_X1 and SQ_X1 < SQ_X24 + RC and SQ_Y24 < SQ_Y1 and SQ_Y1 < SQ_Y24 + RC) then
							if (R6 = '1') then
								 counter2 <= counter2 + 1;
								 B6 <= '1';
								 C6 <= 1;
							else
								 B6_W <= '1';
							end if;							
					  elsif (SQ_X25 < SQ_X1 and SQ_X1 < SQ_X25 + RC and SQ_Y25 < SQ_Y1 and SQ_Y1 < SQ_Y25 + RC) then
							if (R7 = '1') then
								 counter2 <= counter2 + 1;
								 B7 <= '1';
								 C7 <= 1;
							else
								 B7_W <= '1';
							end if;							
					  elsif (SQ_X26 < SQ_X1 and SQ_X1 < SQ_X26 + RC and SQ_Y26 < SQ_Y1 and SQ_Y1 < SQ_Y26 + RC) then
							if (R8 = '1') then
								 counter2 <= counter2 + 1;
								 B8 <= '1';
								 C8 <= 1;
							else
								 B8_W <= '1';
							end if;							
					  elsif (SQ_X27 < SQ_X1 and SQ_X1 < SQ_X27 + RC and SQ_Y27 < SQ_Y1 and SQ_Y1 < SQ_Y27 + RC) then
							if (R9 = '1') then
								 counter2 <= counter2 + 1;
								 B9 <= '1';
								 C9 <= 1;
							else
								 B9_W <= '1';
							end if;							
					  elsif (SQ_X28 < SQ_X1 and SQ_X1 < SQ_X28 + RC and SQ_Y28 < SQ_Y1 and SQ_Y1 < SQ_Y28 + RC) then
							if (R10 = '1') then
								 counter2 <= counter2 + 1;
								 B10 <= '1';
								 C10 <= 1;
							else
								 B10_W <= '1';
							end if;							
					  elsif (SQ_X29 < SQ_X1 and SQ_X1 < SQ_X29 + RC and SQ_Y29 < SQ_Y1 and SQ_Y1 < SQ_Y29 + RC) then
							if (R11 = '1') then
								 counter2 <= counter2 + 1;
								 B11 <= '1';
								 C11 <= 1;
							else
								 B11_W <= '1';
							end if;							
					  elsif (SQ_X30 < SQ_X1 and SQ_X1 < SQ_X30 + RC and SQ_Y30 < SQ_Y1 and SQ_Y1 < SQ_Y30 + RC) then
							if (R12 = '1') then
								 counter2 <= counter2 + 1;
								 B12 <= '1';
								 C12 <= 1;
							else
								 B12_W <= '1';
							end if;
					  elsif (SQ_X31 < SQ_X1 and SQ_X1 < SQ_X31 + RC and SQ_Y31 < SQ_Y1 and SQ_Y1 < SQ_Y31 + RC) then
							if (R13 = '1') then
								 counter2 <= counter2 + 1;
								 B13 <= '1';
								 C13 <= 1;
							else
								 B13_W <= '1';
							end if;							
					  elsif (SQ_X32 < SQ_X1 and SQ_X1 < SQ_X32 + RC and SQ_Y32 < SQ_Y1 and SQ_Y1 < SQ_Y32 + RC) then
							if (R14 = '1') then
								 counter2 <= counter2 + 1;
								 B14 <= '1';
								 C14 <= 1;
							else
								 B14_W <= '1';
							end if;
					  elsif (SQ_X33 < SQ_X1 and SQ_X1 < SQ_X33 + RC and SQ_Y33 < SQ_Y1 and SQ_Y1 < SQ_Y33 + RC) then
							if (R15 = '1') then
								 counter2 <= counter2 + 1;
								 B15 <= '1';
								 C15 <= 1;
							else
								 B15_W <= '1';
							end if;
					  elsif (SQ_X34 < SQ_X1 and SQ_X1 < SQ_X34 + RC and SQ_Y34 < SQ_Y1 and SQ_Y1 < SQ_Y34 + RC) then
							if (R16 = '1') then
								 counter2 <= counter2 + 1;
								 B16 <= '1';
								 C16 <= 1;
							else
								 B16_W <= '1';
							end if;










							
---------------------------------------------------------------------							

					  end if;
					  
					  
				 end if;
				
				
				
-----------------------------clock high's end if------------------------------				
        end if;
    end process;
------------------------------------------------------------------------------AI CHOOSES-----------------------------------------------------------------------------
	process(SLOWER_CLK)  -- clock 5 sn'de 1 data alsın.
		begin
			if rising_edge(SLOWER_CLK) then
				if(SW4 = '1')then
					counter_L <= counter_L +1;
					if(SW0 ='1')then
						if(counter_L rem 16 = 0)then
							IF(L3 = '1')THEN
								G3 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G3_W <='1';
							END IF;
						elsif(counter_L rem 16 =1)then
							IF(L7 ='1')then
								G7 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G7_W <='1';
							END IF;
						elsif(counter_L rem 16 =2)then
							IF(L15 = '1')then
								G15 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G15_W <='1';
							END IF;
						elsif(counter_L rem 16 =3)then
							IF(L16 ='1')then
								G16 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G16_W <='1';
							END IF;
						elsif(counter_L rem 16 =4)then
							IF(L9 = '1')then
								G9 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G9_W <='1';
							END IF;
						elsif(counter_L rem 16 =5)then
							IF(L10 ='1')then
								G10 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G10_W <='1';
							END IF;
						elsif(counter_L rem 16 =6)then
							IF(L4 = '1')then
								G4 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G4_W <='1';
							END IF;
						elsif(counter_L rem 16 =7)then
							IF(L11 ='1')then
								G11 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G11_W <='1';
							END IF;
						elsif(counter_L rem 16 =8)then
							IF(L1 = '1')then
								G1 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G1_W <='1';
							END IF;					
						elsif(counter_L rem 16 =9)then
							IF(L13 ='1')then
								G13 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G13_W <='1';
							END IF;
						elsif(counter_L rem 16 =10)then
							IF(L6 = '1')then
								G6 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G6_W <='1';
							END IF;
						elsif(counter_L rem 16 =11)then
							IF(L8 ='1')then
								G8 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G8_W <='1';
							END IF;
						elsif(counter_L rem 16 =12)then
							IF(L14 = '1')then
								G14 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G14_W <='1';
							END IF;
						elsif(counter_L rem 16 =13)then
							IF(L2 ='1')then
								G2 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G2_W <='1';
							END IF;
						elsif(counter_L rem 16 =14)then
							IF(L5 = '1')then
								G5 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G5_W <='1';
							END IF;
						elsif(counter_L rem 16 =15)then
							IF(L12 ='1')then
								G12 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G12_W <='1';
							END IF;
						END IF;
	-----------------------------------second guessing pattern below--------------------Counter can be 0 at the end of last predictions			
					ELSIF(SW1 ='1')then
						if(counter_L rem 16 = 0)then
							IF(L11 = '1')THEN
								G11 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G11_W <='1';
							END IF;
						elsif(counter_L rem 16 =1)then
							IF(L6 ='1')then
								G6 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G6_W <='1';
							END IF;
						elsif(counter_L rem 16 =2)then
							IF(L14 = '1')then
								G14 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G14_W <='1';
							END IF;
						elsif(counter_L rem 16 =3)then
							IF(L4 ='1')then
								G4 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G4_W <='1';
							END IF;
						elsif(counter_L rem 16 =4)then
							IF(L12 = '1')then
								G12 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G12_W <='1';
							END IF;
						elsif(counter_L rem 16 =5)then
							IF(L1 ='1')then
								G1 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G1_W <='1';
							END IF;
						elsif(counter_L rem 16 =6)then
							IF(L9 = '1')then
								G9 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G9_W <='1';
							END IF;
						elsif(counter_L rem 16 =7)then
							IF(L2 ='1')then
								G2 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G2_W <='1';
							END IF;
						elsif(counter_L rem 16 =8)then
							IF(L16 = '1')then
								G16 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G16_W <='1';
							END IF;					
						elsif(counter_L rem 16 =9)then
							IF(L3 ='1')then
								G3 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G3_W <='1';
							END IF;
						elsif(counter_L rem 16 =10)then
							IF(L5 = '1')then
								G5 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G5_W <='1';
							END IF;
						elsif(counter_L rem 16 =11)then
							IF(L8 ='1')then
								G8 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G8_W <='1';
							END IF;
						elsif(counter_L rem 16 =12)then
							IF(L13 = '1')then
								G13 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G13_W <='1';
							END IF;
						elsif(counter_L rem 16 =13)then
							IF(L15 ='1')then
								G15 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G15_W <='1';
							END IF;
						elsif(counter_L rem 16 =14)then
							IF(L7 = '1')then
								G7 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G7_W <='1';
							END IF;
						elsif(counter_L rem 16 =15)then
							IF(L10 ='1')then
								G10 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G10_W <='1';
							END IF;
						END IF;					
		-----------------------------------Third guessing pattern--------------------					
					ELSIF(SW2 ='1')then
						if(counter_L rem 16 = 0)then
							IF(L7 = '1')THEN
								G7 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G7_W <='1';
							END IF;
						elsif(counter_L rem 16 =1)then
							IF(L11 ='1')then
								G11 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G11_W <='1';
							END IF;
						elsif(counter_L rem 16 =2)then
							IF(L9 = '1')then
								G9 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G9_W <='1';
							END IF;
						elsif(counter_L rem 16 =3)then
							IF(L13 ='1')then
								G13 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G13_W <='1';
							END IF;
						elsif(counter_L rem 16 =4)then
							IF(L2 = '1')then
								G2 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G2_W <='1';
							END IF;
						elsif(counter_L rem 16 =5)then
							IF(L16 ='1')then
								G16 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G16_W <='1';
							END IF;
						elsif(counter_L rem 16 =6)then
							IF(L10 = '1')then
								G10 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G10_W <='1';
							END IF;
						elsif(counter_L rem 16 =7)then
							IF(L3 ='1')then
								G3 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G3_W <='1';
							END IF;
						elsif(counter_L rem 16 =8)then
							IF(L5 = '1')then
								G5 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G5_W <='1';
							END IF;					
						elsif(counter_L rem 16 =9)then
							IF(L12 ='1')then
								G12 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G12_W <='1';
							END IF;
						elsif(counter_L rem 16 =10)then
							IF(L4 = '1')then
								G4 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G4_W <='1';
							END IF;
						elsif(counter_L rem 16 =11)then
							IF(L15 ='1')then
								G15 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G15_W <='1';
							END IF;
						elsif(counter_L rem 16 =12)then
							IF(L1 = '1')then
								G1 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G1_W <='1';
							END IF;
						elsif(counter_L rem 16 =13)then
							IF(L6 ='1')then
								G6 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G6_W <='1';
							END IF;
						elsif(counter_L rem 16 =14)then
							IF(L14 = '1')then
								G14 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G14_W <='1';
							END IF;
						elsif(counter_L rem 16 =15)then
							IF(L8 ='1')then
								G8 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G8_W <='1';
							END IF;
						END IF;					
		-----------------------------------Fourth guessing pattern--------------------					
					ELSIF(SW3 ='1')then
						if(counter_L rem 16 = 0)then
							IF(L14 = '1')THEN
								G14 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G14_W <='1';
							END IF;
						elsif(counter_L rem 16 =1)then
							IF(L12 ='1')then
								G12 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G12_W <='1';
							END IF;
						elsif(counter_L rem 16 =2)then
							IF(L4 = '1')then
								G4 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G4_W <='1';
							END IF;
						elsif(counter_L rem 16 =3)then
							IF(L6 ='1')then
								G6 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G6_W <='1';
							END IF;
						elsif(counter_L rem 16 =4)then
							IF(L9 = '1')then
								G9 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G9_W <='1';
							END IF;
						elsif(counter_L rem 16 =5)then
							IF(L10 ='1')then
								G10 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G10_W <='1';
							END IF;
						elsif(counter_L rem 16 =6)then
							IF(L11 = '1')then
								G11 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G11_W <='1';
							END IF;
						elsif(counter_L rem 16 =7)then
							IF(L15 ='1')then
								G15 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G15_W <='1';
							END IF;
						elsif(counter_L rem 16 =8)then
							IF(L1 = '1')then
								G1 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G1_W <='1';
							END IF;					
						elsif(counter_L rem 16 =9)then
							IF(L8 ='1')then
								G8 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G8_W <='1';
							END IF;
						elsif(counter_L rem 16 =10)then
							IF(L3 = '1')then
								G3 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G3_W <='1';
							END IF;
						elsif(counter_L rem 16 =11)then
							IF(L7 ='1')then
								G7 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G7_W <='1';
							END IF;
						elsif(counter_L rem 16 =12)then
							IF(L16 = '1')then
								G16 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G16_W <='1';
							END IF;
						elsif(counter_L rem 16 =13)then
							IF(L5 ='1')then
								G5 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G5_W <='1';
							END IF;
						elsif(counter_L rem 16 =14)then
							IF(L2 = '1')then
								G2 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G2_W <='1';
							END IF;
						elsif(counter_L rem 16 =15)then
							IF(L13 ='1')then
								G13 <= '1';
								counter_W <= counter_W +1;
							ELSE
								G13_W <='1';
							END IF;
						END IF;					
--------------------------------------------------end of predictions---------------------------						
					END IF;		
				end if;
				
--------------------				
			end if;		
	end process;
----------------------------------------Predictions with low clock---------------------------------
 
-------------------------------- choose MAP----------------------------------------------------------------------

	process(CLK25)
		begin
		if(SW4 = '1')THEN
	     if(SW0 = '1')then
				R1 <= '1';
				R2 <= '0';
				R3 <= '0';
				R4 <= '1';
				R5 <= '1';
				R6 <= '0';
				R7 <= '0';
				R8 <= '1';
				R9 <= '1';
				R10 <= '0';
				R11 <= '0';
				R12 <= '0';
				R13 <= '0';
				R14 <= '0';
				R15 <= '0';
				R16 <= '1';
				
        elsif(SW1 = '1')then
				R1 <= '0';
				R2 <= '1';
				R3 <= '0';
				R4 <= '0';
				R5 <= '0';
				R6 <= '1';
				R7 <= '0';
				R8 <= '0';
				R9 <= '1';
				R10 <= '0';
				R11 <= '0';
				R12 <= '0';
				R13 <= '0';
				R14 <= '1';
				R15 <= '1';
				R16 <= '1';
        elsif(SW2 = '1')then
				R1 <= '1';
				R2 <= '1';
				R3 <= '0';
				R4 <= '0';
				R5 <= '0';
				R6 <= '1';
				R7 <= '1';
				R8 <= '1';
				R9 <= '0';
				R10 <= '0';
				R11 <= '0';
				R12 <= '0';
				R13 <= '1';
				R14 <= '0';
				R15 <= '0';
				R16 <= '0';			
        elsif(SW3 = '1')then
				R1 <= '0';
				R2 <= '1';
				R3 <= '1';
				R4 <= '1';
				R5 <= '0';
				R6 <= '0';
				R7 <= '0';
				R8 <= '0';
				R9 <= '1';
				R10 <= '0';
				R11 <= '1';
				R12 <= '0';
				R13 <= '1';
				R14 <= '0';
				R15 <= '0';
				R16 <= '0';				
        end if;
		end if;
		end process;


--------------------
	process(CLK25)
		begin

			if (CLK25'event and CLK25='1') then	
				if (Hcnt = HM) then
					Hcnt <= "0000000000";
               if (Vcnt= VM) then
                  Vcnt <= "0000000000";
                  activecam_o <= '1';
               else
                  if rez_160x120 = '1' then
                     if vCnt < 120-1 then
                        activecam_o <= '1';
								
                     end if;
                  elsif rez_320x240 = '1' then
                     if vCnt < 240-1 then
                        activecam_o <= '1';
                     end if;
                  else
                     if vCnt < 480-1 then
                        activecam_o <= '1';
                     end if;
                  end if;
                  Vcnt <= Vcnt+1;
               end if;
				else
               if rez_160x120 = '1' then
                  if hcnt = 160-1 then
                     activecam_o <= '0';
                  end if;
               elsif rez_320x240 = '1' then
                  if hcnt = 320-1 then
                     activecam_o <= '0';
                  end if;
               else
                  if hcnt = 640-1 then
                     activecam_o <= '0';
                  end if;
               end if;
					Hcnt <= Hcnt + 1;
				end if;
			end if;
		end process;	
   process(video)
   begin



     -----DRAW BACKGROUND BLACK---- square
		IF(DRAW1='1')THEN
		   IF(S(0)='1')THEN
			 R <= (others => '1');
			 G <= (others => '0');
			 B <= (others => '0');
			ELSE
			 R <= (others => '1');
			 G <= (others => '1');
			 B <= (others => '1');	  
			END IF;
		END IF;
		IF(DRAW2='1')THEN
		   IF(S(1)='1')THEN
			 R <= (others => '1');
			 G <= (others => '0');
			 B <= (others => '0');
			ELSE
			 R <= (others => '1');
			 G <= (others => '1');
			 B <= (others => '1');	  
			END IF;
		END IF;	
		IF(DRAW1='0' AND DRAW2 ='0')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '0');			
		END IF;
-------------------------------------------------------Plane------------------------------	
		IF(DRAW3='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW4='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
			
		END IF;
		IF(DRAW5='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW6='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;			
		IF(DRAW7='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW8='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW9='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW10='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW11='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW12='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW13='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW14='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW15='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW16='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW17='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW18='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
-------------------------------------------right---------------
		IF(DRAW19='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW20='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
			
		END IF;
		IF(DRAW21='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW22='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;			
		IF(DRAW23='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW24='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW25='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW26='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW27='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW28='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW29='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW30='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW31='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW32='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW33='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		IF(DRAW34='1')THEN
			 R <= (others => '0');
			 G <= (others => '0');
			 B <= (others => '1');
		END IF;
		
------------------------------------Upper side is map and lower side is true or false correction-------------------------------------------
		if(B1 ='1')THEN
			IF(DRAW_1='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B1_W ='1')THEN
			IF(DRAW_1='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B2 ='1')THEN
			IF(DRAW_2='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B2_W ='1')THEN
			IF(DRAW_2='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B3 ='1')THEN
			IF(DRAW_3='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B3_W ='1')THEN
			IF(DRAW_3='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B4 ='1')THEN
			IF(DRAW_4='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B4_W ='1')THEN
			IF(DRAW_4='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;

		if(B5 ='1')THEN
			IF(DRAW_5='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B5_W ='1')THEN
			IF(DRAW_5='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B6 ='1')THEN
			IF(DRAW_6='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B6_W ='1')THEN
			IF(DRAW_6='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B7 ='1')THEN
			IF(DRAW_7='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B7_W ='1')THEN
			IF(DRAW_7='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
				 counter_P <= counter_P +1;
			END IF;
		end if;
		
		if(B8 ='1')THEN
			IF(DRAW_8='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B8_W ='1')THEN
			IF(DRAW_8='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
	
		if(B9 ='1')THEN
			IF(DRAW_9='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B9_W ='1')THEN
			IF(DRAW_9='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B10 ='1')THEN
			IF(DRAW_10='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B10_W ='1')THEN
			IF(DRAW_10='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B11 ='1')THEN
			IF(DRAW_11='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B11_W ='1')THEN
			IF(DRAW_11='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B12 ='1')THEN
			IF(DRAW_12='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B12_W ='1')THEN
			IF(DRAW_12='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;

		if(B13 ='1')THEN
			IF(DRAW_13='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B13_W ='1')THEN
			IF(DRAW_13='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B14 ='1')THEN
			IF(DRAW_14='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B14_W ='1')THEN
			IF(DRAW_14='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B15 ='1')THEN
			IF(DRAW_15='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B15_W ='1')THEN
			IF(DRAW_15='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(B16 ='1')THEN
			IF(DRAW_16='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(B16_W ='1')THEN
			IF(DRAW_16='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
------------------------------------------------------------Ships of the player--------------------------------------
		if(L1 ='1')THEN
			IF(DRAW_1U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
		
		if(L2 ='1')THEN
			IF(DRAW_2U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
		
		if(L3 ='1')THEN
			IF(DRAW_3U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
		
		if(L4 ='1')THEN
			IF(DRAW_4U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;

		if(L5 ='1')THEN
			IF(DRAW_5U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
		
		if(L6 ='1')THEN
			IF(DRAW_6U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
		
		if(L7 ='1')THEN
			IF(DRAW_7U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
		
		if(L8 ='1')THEN
			IF(DRAW_8U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
	


		if(L9 ='1')THEN
			IF(DRAW_9U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
		
		if(L10 ='1')THEN
			IF(DRAW_10U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
		
		if(L11 ='1')THEN
			IF(DRAW_11U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;

		end if;
		
		if(L12 ='1')THEN
			IF(DRAW_12U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;

		end if;

		if(L13 ='1')THEN
			IF(DRAW_13U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;

		end if;
		
		if(L14 ='1')THEN
			IF(DRAW_14U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;

		end if;
		
		if(L15 ='1')THEN
			IF(DRAW_15U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
		
		if(L16 ='1')THEN
			IF(DRAW_16U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '1');
			END IF;
		end if;
----------------------------------------------------------True or False for PC------------------------
		if(G1 ='1')THEN
			IF(DRAW_1U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G1_W ='1')THEN
			IF(DRAW_1U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G2 ='1')THEN
			IF(DRAW_2U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G2_W ='1')THEN
			IF(DRAW_2U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G3 ='1')THEN
			IF(DRAW_3U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G3_W ='1')THEN
			IF(DRAW_3U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G4 ='1')THEN
			IF(DRAW_4U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G4_W ='1')THEN
			IF(DRAW_4U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;

				if(G5 ='1')THEN
			IF(DRAW_5U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G5_W ='1')THEN
			IF(DRAW_5U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G6 ='1')THEN
			IF(DRAW_6U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G6_W ='1')THEN
			IF(DRAW_6U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G7 ='1')THEN
			IF(DRAW_7U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G7_W ='1')THEN
			IF(DRAW_7U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G8 ='1')THEN
			IF(DRAW_8U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G8_W ='1')THEN
			IF(DRAW_8U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
	


		if(G9 ='1')THEN
			IF(DRAW_9U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G9_W ='1')THEN
			IF(DRAW_9U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G10 ='1')THEN
			IF(DRAW_10U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G10_W ='1')THEN
			IF(DRAW_10U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G11 ='1')THEN
			IF(DRAW_11U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G11_W ='1')THEN
			IF(DRAW_11U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G12 ='1')THEN
			IF(DRAW_12U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G12_W ='1')THEN
			IF(DRAW_12U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;

				if(G13 ='1')THEN
			IF(DRAW_13U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G13_W ='1')THEN
			IF(DRAW_13U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G14 ='1')THEN
			IF(DRAW_14U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G14_W ='1')THEN
			IF(DRAW_14U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G15 ='1')THEN
			IF(DRAW_15U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G15_W ='1')THEN
			IF(DRAW_15U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;
		
		if(G16 ='1')THEN
			IF(DRAW_16U='1')THEN
				 R <= (others => '0');
				 G <= (others => '1');
				 B <= (others => '0');
			END IF;
		elsif(G16_W ='1')THEN
			IF(DRAW_16U='1')THEN
				 R <= (others => '1');
				 G <= (others => '0');
				 B <= (others => '0');
			END IF;
		end if;

counter_P2 <= C1+C2+C3+C4+C5+C6+C7+C8+C9+C10+C11+C12+C13+C14+C15+C16;
----------------------------------------------------------------WINNER-------------------------------------
	if(counter_P2 = 6)then
if (
--W
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 202)) or
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 211)) or
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 219)) or
(pixel_row = 188 and pixel_column > 202 and pixel_column < 219) or
--O
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 222)) or
(pixel_row = 170 and pixel_column > 222 and pixel_column < 234) or 
(pixel_row = 188 and pixel_column > 222 and pixel_column < 234) or 
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 234)) or
--N
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 237)) or
(pixel_row = 170 and pixel_column > 237 and pixel_column < 249) or 
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 249))
)
then
      R <= (others => '1');
      G <= (others => '0');
      B <= (others => '0');
end if;
end if;

	if(counter_w = 6)then
if (
--W
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 442)) or
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 451)) or
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 459)) or
(pixel_row = 188 and pixel_column > 442 and pixel_column < 459) or
--O
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 462)) or
(pixel_row = 170 and pixel_column > 462 and pixel_column < 474) or 
(pixel_row = 188 and pixel_column > 462 and pixel_column < 474) or 
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 474)) or
--N
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 477)) or
(pixel_row = 170 and pixel_column > 477 and pixel_column < 489) or 
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 489))
)
then
      R <= (others => '1');
      G <= (others => '0');
      B <= (others => '0');
end if;
end if;
----------------------Lines----------------	-----------------------BATTLESHIP-------------------------------------------------------------------  
	  if (pixel_row > 120 and pixel_column = 320)then
	  R <= (others => '1');
	  G <= (others => '1');
	  B <= (others => '1');
	  end if;
	  if (pixel_row = 120 and pixel_column > 0)then
	  R <= (others => '1');
	  G <= (others => '1');
	  B <= (others => '1');
	  end if;
	  if (
--B 
(pixel_row >= 45 and pixel_row < 75 and (pixel_column = 147 or pixel_column = 177)) or
(pixel_row = 45 and pixel_column > 147 and pixel_column < 177) or
(pixel_row = 60 and pixel_column > 147 and pixel_column < 177) or
(pixel_row = 75 and pixel_column > 147 and pixel_column < 177) or
-- A 
(pixel_row >= 45 and pixel_row < 75 and (pixel_column = 182 or pixel_column = 212)) or
(pixel_row = 45 and pixel_column > 182 and pixel_column < 212) or
(pixel_row = 60 and pixel_column > 182 and pixel_column < 212) or
--T 
(pixel_row = 45 and pixel_column > 217 and pixel_column < 247) or
(pixel_row >= 45 and pixel_row < 75 and (pixel_column = 232)) or
-- T 
(pixel_row = 45 and pixel_column > 252 and pixel_column < 282) or
(pixel_row >= 45 and pixel_row < 75 and (pixel_column = 267)) or
-- L 
(pixel_row >= 45 and pixel_row < 75 and (pixel_column = 287)) or
(pixel_row = 75 and pixel_column > 287 and pixel_column < 317) or
-- E 
(pixel_row >= 45 and pixel_row < 75 and (pixel_column = 322)) or
(pixel_row = 45 and pixel_column > 322 and pixel_column < 352) or
(pixel_row = 60 and pixel_column > 322 and pixel_column < 352) or
(pixel_row = 75 and pixel_column > 322 and pixel_column < 352) or

-- S 
(pixel_row = 45 and pixel_column > 357 and pixel_column < 387) or
(pixel_row = 60 and pixel_column > 357 and pixel_column < 387) or
(pixel_row = 75 and pixel_column > 357 and pixel_column < 387) or
(pixel_row >= 45 and pixel_row < 60 and (pixel_column = 357)) or
(pixel_row >= 60 and pixel_row < 75 and (pixel_column = 387)) or
--H 
(pixel_row >= 45 and pixel_row < 75 and (pixel_column = 392 or pixel_column = 422)) or
(pixel_row = 60 and pixel_column > 392 and pixel_column < 422) or
-- I 
(pixel_row = 45 and pixel_column > 427 and pixel_column < 457) or
(pixel_row = 75 and pixel_column > 427 and pixel_column < 457) or
(pixel_row >= 45 and pixel_row < 75 and (pixel_column = 442)) or
-- P 
(pixel_row >= 45 and pixel_row < 75 and (pixel_column = 462)) or
(pixel_row = 45 and pixel_column > 462 and pixel_column < 492) or
(pixel_row = 60 and pixel_column > 462 and pixel_column < 492) or
(pixel_row >= 45 and pixel_row < 60 and (pixel_column = 492))


) then
    R <= (others => '1');
    G <= (others => '0');
    B <= (others => '1');
end if;

	  if (
	  --P Harfi
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 100 )) or
(pixel_row = 170 and pixel_column > 100 and pixel_column < 112) or
(pixel_row = 179 and pixel_column > 100 and pixel_column < 112) or
(pixel_row >= 170 and pixel_row < 179 and (pixel_column = 112)) or
--L Harfi
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 115)) or
(pixel_row = 188 and pixel_column > 115 and pixel_column < 127) or
--A Harfi
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 130 or pixel_column = 142)) or
(pixel_row = 170 and pixel_column > 130 and pixel_column < 142) or
(pixel_row = 179 and pixel_column > 130 and pixel_column < 142) or
--Y Harfi
(pixel_row >= 170 and pixel_row < 179 and (pixel_column = 145 or pixel_column = 157)) or
(pixel_row >= 179 and pixel_row < 189 and (pixel_column = 151)) or
(pixel_row = 179 and pixel_column > 145 and pixel_column < 157) or
--E Harfi
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 160)) or
(pixel_row = 170 and pixel_column > 160 and pixel_column < 172) or
(pixel_row = 179 and pixel_column > 160 and pixel_column < 172) or
(pixel_row = 188 and pixel_column > 160 and pixel_column < 172) or
--R Harfi
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 175 )) or
(pixel_row >= 170 and pixel_row < 179 and (pixel_column = 187 )) or
(pixel_row = 170 and pixel_column > 175 and pixel_column < 187) or
(pixel_row = 179 and pixel_column > 175 and pixel_column < 192) or
(pixel_row >= 179 and pixel_row < 189 and (pixel_column = 192))
)
then
	  R <= (others => '1');
	  G <= (others => '1');
	  B <= (others => '1');
	  end if;
  if (
	  -- P Harfi
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 400 )) or
(pixel_row = 170 and pixel_column > 400 and pixel_column < 412) or
(pixel_row = 179 and pixel_column > 400 and pixel_column < 412) or
(pixel_row >= 170 and pixel_row < 179 and (pixel_column = 412)) or
-- (Boşluk)
--C Harfi
(pixel_row >= 170 and pixel_row < 189 and (pixel_column = 415)) or
(pixel_row = 170 and pixel_column > 415 and pixel_column < 427) or
(pixel_row = 188 and pixel_column > 415 and pixel_column < 427)
)
then
	  R <= (others => '1');
	  G <= (others => '1');
	  B <= (others => '1');
	  end if;
	  
	  
	  
end process;
   
	process(CLK25)
		begin
			if (CLK25'event and CLK25='1') then
				if (Hcnt >= (HD+HF) and Hcnt <= (HD+HF+HR-1)) then   --- Hcnt >= 656 and Hcnt <= 751
					Hsync <= '0';

				else
					Hsync <= '1';
				end if;
			end if;
		end process;

	process(CLK25)
		begin
			if (CLK25'event and CLK25='1') then
				if (Vcnt >= (VD+VF) and Vcnt <= (VD+VF+VR-1)) then  ---Vcnt >= 490 and vcnt<= 491
					Vsync <= '0';
				else
					Vsync <= '1';
				end if;
			end if;
		end process;

	 hex2led: entity work.hex2led
		port map(			
			HEX => std_logic_vector(to_unsigned(counter_W, 4)),
			LED => ledOut_C
	 );
	 hex2led2: entity work.hex2led
		port map(			
			HEX => STD_LOGIC_VECTOR(to_unsigned(counter_P2, 4)),
			LED => ledOut_P
	 );
	 

Nsync <= '1';
video <= '1' when (Hcnt < HD) and (Vcnt < VD) else '0';
Nblank <= video;
		
end Behavioral;