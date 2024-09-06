library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;

---------------------- MIPS datapath ---------------------
-- Esse módulo é composto pela unidade lógica aritmética -
-- (ula) pelo register file (refile) e lógicas associadas-
--                                                       -
-- Para uma melhor compreensão sobre os sinais de entrada-
-- e saída, consulte a figura 7.59 do livro (ou slides). -
----------------------------------------------------------  

entity datapath is  
  port(clk, reset:        in  STD_LOGIC;
       memtoreg, pcsrc:   in  STD_LOGIC;
       alusrc, regdst:    in  STD_LOGIC;
       regwrite, jump:    in  STD_LOGIC;
       alucontrol:        in  STD_LOGIC_VECTOR(2 downto 0);
       zero:              out STD_LOGIC;
       pc:                buffer STD_LOGIC_VECTOR(31 downto 0);
       instr:             in  STD_LOGIC_VECTOR(31 downto 0);
       aluout, writedata: buffer STD_LOGIC_VECTOR(31 downto 0);
       readdata:          in  STD_LOGIC_VECTOR(31 downto 0));
end datapath;

architecture struct of datapath is
  -- importa todos os componentes necessários
  component ula
    port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
         alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
         result:     buffer STD_LOGIC_VECTOR(31 downto 0);
         zero:       out STD_LOGIC);
  end component;
  component regfile
    port(clk:           in  STD_LOGIC;
         we3:           in  STD_LOGIC;
         ra1, ra2, wa3: in  STD_LOGIC_VECTOR(4 downto 0);
         wd3:           in  STD_LOGIC_VECTOR(31 downto 0);
         rd1, rd2:      out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component adder
    port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
         y:    out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component sl2
    port(a: in  STD_LOGIC_VECTOR(31 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component signext
    port(a: in  STD_LOGIC_VECTOR(15 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component reg generic(s: integer);
    port(clk, reset: in  STD_LOGIC;
         d:          in  STD_LOGIC_VECTOR(s-1 downto 0);
         q:          out STD_LOGIC_VECTOR(s-1 downto 0));
  end component;
  component mux2 generic(t: integer);
    port(d0, d1: in  STD_LOGIC_VECTOR(t-1 downto 0);
         s:      in  STD_LOGIC;
         y:      out STD_LOGIC_VECTOR(t-1 downto 0));
  end component;
  
  signal writereg:           STD_LOGIC_VECTOR(4 downto 0);
  signal pcjump, pcnext, 
         pcnextbr, pcplus4, 
         pcbranch:           STD_LOGIC_VECTOR(31 downto 0);
  signal signimm, signimmsh: STD_LOGIC_VECTOR(31 downto 0);
  signal srca, srcb, result: STD_LOGIC_VECTOR(31 downto 0);
begin
  
  -------------------- Implemente a lógica para calcular o próximo valor do PC --------------------- 
   
	--JUMP
	G1: adder port map(pc, "100", pcplus4); --Cálculo de pc + 4
	pcjump <= pcplus4(31 downto 28) & (instr(25 downto 0) & "00"); --Cálculo do pc para o caso de Jump

	--BRANCH
	G2: signext port map(instr(15 downto 0), signimm); --Cálculo do imediato extendido com sinal
	G3: sl2 port map(signimm, signimmsh); --Cálculo do signimmsh
	G4: adder port map(pcplus4, signimmsh, pcbranch); --Cálculo do pcbranch
 
	--Mux para determinar se é função branch
	G5: mux2 generic map(t => 32) 
				port map(pcplus4, pcbranch, pcsrc, pcnextbr);
  
	--Mux para determinar se é função jump
	G6: mux2 generic map(t => 32)
		      port map(pcnextbr, pcjump, jump, pcnext);
  
	--Registrador do PC
	G7: reg generic map(s => 32)
			  port map(clk, reset, pcnext, pc);
	
  --------------------- Lógica do register file ------------------------------------------- 
	
	-- Mux para determinar o endereço de gravação do regFile
	G8: mux2 generic map(t => 5)
				port map(instr(20 downto 16), instr(15 downto 11), regdst, writereg);
	
	--Mux para determinar se o regFile irá guardar o resultado da ULA, ou um valor da memória de dados
	G9: mux2 generic map(t => 32)
				port map(aluout, readdata, memtoreg, result);
  
	--Register File
	G10: regfile port map(clk, regwrite, instr(25 downto 21), instr(20 downto 16), writereg, result, srca, writedata);
  
  ---------------------- Logica da ULA ----------------------------------------------------------------------------
  
	--Mux para determinar a segunda entrada da ULA entre o segundo registrador e o imediato extendido com sinal
	G11: mux2 generic map(t => 32)
				 port map(writedata, signimm, alusrc, srcb);

   --Unidade Lógiga e Aritmética (ULA)
	G12: ula port map(srca, srcb, alucontrol, aluout, zero);
  
end;
