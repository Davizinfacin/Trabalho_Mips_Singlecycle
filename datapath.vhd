library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;

---------------------- MIPS datapath --------------------
- Esse módulo é composto pela unidade lógica aritmética -
- (ula) pelo register file (refile) e lógicas associadas-
-                                                       -
- Para uma melhor compreensão sobre os sinais de entrada-
- e saída, consulte a figura 7.59 do livro (ou slides). -
---------------------------------------------------------  

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
  
  -- Calcule o valor de pc para o caso de uma instrução J e coloque o resultado no sinal pcjump. 
  -- Use um adder para calcular pc+4 e coloque o resultado no sinal pcplus4. Em seguida, calcule
  -- pcjump = pcplus4[31 a 28] & instr[25 a 0] & "00" (detalhes na seção 7.3.3 e figura 7.14)
  


  -- Calcule o valor de pc para o caso de uma instruçãoao beq e coloque o resultado no sinal pcbranch. 
  -- use um extensor de sinal signext, um deslocador e um adder para o calculo. 
  -- pcbranch = sigext(instr[15 a 0]) << 2 + pcplus4 (detalhes na figura 7.10 do livro) 
  
 
  
  -- Defina o primeiro mux2 que Seleciona entre pcplus4 e pcbranch, com base em pcsrc.
  -- saida em pcnextbr (PC´) (ver figura 7.14)
  

  
  -- Defina o segundo mux2 que Seleciona entre pcnextbr (PC´) e pcjump, com base no sinal jump.
  -- saida em pcnext (ver figura 7.14)
  

  
  -- Defina o registrador PC, alimentado por pcnext, e controlado pelo clk e reset.
  -- A saída desse registrador deve ir para o sinal pc (buffer) que alimentará a entrada de
  -- endereço da memória de instrução (ver figura 7.59 do livro) 

  
  
  --------------------- Lógica do register file -------------------------------------------
  
  -- Defina o multiplexador que seleciona o endereço de gravação do register file a fim de
  -- diferenciar instruções tipo-R de lw (tipo-I)  
  
  
  -- Defina o multiplexador que alimenta a entrada de dados (wd3) do register file. Esse mux2 
  -- seleciona entre a saida da ula e a saída da memória de dados (ver figura 7.14)
  

  
  -- Defina o register file com saídas em srca e writedata (ver figura 7.14)
  

  ---------------------- Logica da ULA ----------------------------------------------------------------------------
  
  -- Defina o multiplexador que seleciona entre a saida B (writedata) do register file e o imediato extendido (signimm).
  -- Saida em srcb, que vai para a segunda entrada da ula (ver figura 7.14)
  
  
  -- Defina a ula, com o resultado da operação em aluout e bit zero (ver figura 7.14). 
  
end;