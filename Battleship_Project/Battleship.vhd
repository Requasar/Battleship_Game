library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;

entity Battleship is
port( 
	   clk	      :	IN   STD_LOGIC;
		rst			:  IN   STD_LOGIC;
----------------------------------------------------------------------------
------VGA ------------------------------------------------------------------		
	   h_sync		:	OUT  STD_LOGIC;	--horiztonal sync pulse
	   v_sync		:	OUT  STD_LOGIC;	--vertical sync pulse
	   vga_clock   :	OUT  STD_LOGIC;   --pixel clock at frequency of VGA mode being used
	   n_blank		:	OUT  STD_LOGIC;	--direct blacking output to DAC
	   n_sync		:	OUT  STD_LOGIC;   --sync-on-green output to DAC
	   red			:	OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
	   green	      :	OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
	   blue	      :	OUT  STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); --blue magnitude output to DAC
		ledOut_P    : out std_logic_vector(6 downto 0) := "0000000";
		ledOut_C    : out std_logic_vector(6 downto 0) := "0000000";

--	Square
		KEY         : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		SW          : IN STD_LOGIC_VECTOR(1 DOWNTO 0)	

 ); -- servo motor pwm
end entity;

architecture Behavioral of Battleship is
signal clk_25mhz  : STD_LOGIC;  -- system clock
signal clk_1mhz   : STD_LOGIC;  -- system clock
signal clk_50mhz   : STD_LOGIC;  -- system clock
signal disp_ena   :	STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
signal pixel_clk  :	STD_LOGIC;
signal h_sync_w   :	STD_LOGIC;
signal v_sync_w   :	STD_LOGIC;
signal column	  : INTEGER;		--horizontal pixel coordinate
signal row		  :	INTEGER;		--vertical pixel coordinate


signal active_cam       : STD_LOGIC;
signal resol            : STD_LOGIC_VECTOR(1 downto 0);
--signal config_finished: STD_LOGIC;

signal size_select    : STD_LOGIC_VECTOR(1 downto 0);
	
--------------
signal KEYS_W: STD_LOGIC_VECTOR(9 DOWNTO 0);
signal S_W   : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL ledOut_PW : std_logic_vector(6 downto 0) := "0000000";
SIGNAL ledOut_CW : std_logic_vector(6 downto 0) := "0000000";
	



component clock_pll
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk
		outclk_1 : out std_logic;        -- outclk1.clk
		outclk_2 : out std_logic         -- outclk2.clk
	);
	end component;	
	
begin
KEYS_W      <= KEY;
S_W         <= SW;
h_sync      <= h_sync_w;
v_sync      <= v_sync_w;
vga_clock   <=clk_25mhz;
size_select <=resol;
--ledOut_P		<=ledOut_PW;
--ledOut_C		<=ledOut_PW;



clock_pll_1 :clock_pll
PORT MAP(
		refclk   => clk,
		rst      => '0',
		outclk_0 => clk_25mhz,
		outclk_1 => clk_1mhz,
		outclk_2 => clk_50mhz
	);
	


VGA:entity work.VGA 
PORT MAP(
	    CLK25              => clk_25mhz,
       rez_160x120        => resol(1),
       rez_320x240        => resol(0),
	    Hsync              => h_sync_w,
	    Vsync              => v_sync_w,
	    Nblank             => n_blank,
       activecam_o        => active_cam,
		 reset              => rst,
		 ledOut_P           => ledOut_P,
		 ledOut_C           => ledOut_C,
		 KEYS               => KEYS_W,
		 S 					  => S_W,

	    R 	              => red,
	    G 	              => green,
	    B 	              => blue,

	    Nsync              => n_sync
	);



	
end Behavioral;
