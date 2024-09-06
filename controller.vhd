library IEEE; 
use IEEE.STD_LOGIC_1164.all;

---------------- Unidade de Controle ----------------------
-                                                         -
- Esse módulo implementa a unidade de controle, compondo  -
- os módulos maindec e aludec.                            -
-                                                         -
- Entradas:                                               -
-   op (6 bits): opcode da instrução.                     - 
-   funct (6 bits): campo funct (instruções tipo-R).      -
-   zero (1 bits): bit zero da saída da ula.              -
- Saidas:                                                 -
-   memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite,  -
-   jump e alucontrol são sinais que controlam o datapath.-
-                                                         -
- Para mais detalhes, ver figura 7.59 e seção 7.3.2, 7.3.3-
- do livro indicado, bem com as figuras 7.12 e 7.14 e     -
- tabelas 7.1, 7.2 e 7.3.                                  -
-----------------------------------------------------------

-- É seu trabalho interligar os submódulos da unidade de 
-- controle: maindec e aludec, bem como implementar a 
-- lógica do sinal pcsrc, que é usado como sinal de seleção
-- do primeiro mix na entrada do pc (ver figura 7.14).


entity controller is 
  port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
       zero:               in  STD_LOGIC;
       memtoreg, memwrite: out STD_LOGIC;
       pcsrc, alusrc:      out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
end;


architecture struct of controller is
  component maindec
    port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
         memtoreg, memwrite: out STD_LOGIC;
         branch, alusrc:     out STD_LOGIC;
         regdst, regwrite:   out STD_LOGIC;
         jump:               out STD_LOGIC;
         aluop:              out STD_LOGIC_VECTOR(1 downto 0));
  end component;
  component aludec
    port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
         aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  
  signal aluop:  STD_LOGIC_VECTOR(1 downto 0);
  signal branch: STD_LOGIC;
begin
  -- Faça: Instancie o main decoder (maindec) passando op (opcode) e os 9 sinais de saida.
  -- Referência:  figura 7.11 e 7.12 do livro.
  
  

  --Faça: instancie o alu decoder (aludec) a saida desse modulo deve ser direcionada
  -- para o sinal de saida alucontrol, que controlara a ula (veja figuras 7.11 e 7.12) 
  

  -- Faça: Elabore a lógica do pcsrc usando uma porta and.
  -- Esse bit será o seletor do primeiro mux2 na entrada do PC (veja figura 7.14)
  

end;