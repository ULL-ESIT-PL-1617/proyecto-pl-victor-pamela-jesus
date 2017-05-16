# Gramática

### Ejemplo de uso

    const m = 7, n = 85;  
    var  i,x,y,z,q,r;  
    procedure mult();
       var a, b;
      begin 
         a := x;  b := y; z := 0;
         while b > 0 do
         begin
            if odd x then z := z+a else z := z-a;
            a := 2*a;
            b := b/2;
         end;
      end;
    begin
      x := m;
      y := n;
      call mult();
    end.

Esta es la gramática:

    1.  Σ = { 'VAR', ID, '=', 'FUNCTION', 'IF', 'ELSEIF', 'ELSE', NUM, ADDOP, MULOP, 
              '{', '}', '(', ')', COMPARISONOPERATOR, '||', '&&', 'WHILE' ';' }
    2.  V = { primario, declaracion, asignacion, funcion, instruccion, expression,
              term, factor, condicion, sentencia, bucle, llamada, parametro}
    3.  Producciones:
        1.  primario → (declaracion | (llamada | asignacion))* //Esto es lo que puede haber en global
        2.  declaracion → 'VAR' asignacion 
        3.  asignacion → ID '=' (funcion | expression | asignacion) ';'
        4.  funcion → 'FUNCTION' '(' (parametro)* ')' '{' (instruccion)* '}' ';'
        5.  instruccion → ((declaracion | sentencia | bucle | llamada | asignacion) ';')*
        6.  expression → term ADDOP expression | term 
        7.  term → factor MULOP term | factor
        8.  factor → '(' expression ')' | NUM
        9.  condicion → parametro COMPARISONOPERATOR parametro
        10. sentencia → 'IF' (condicion) '{' instruccion '}' 
            ('ELSEIF' (condicion) '{' instruccion '}')* ('ELSE' '{' instruccion '}')? ';'
        11. bucle → 'WHILE' '(' condicion ')' '{' instruccion '}' ';'
        12. llamada → ID '(' (parametro)* ')' ';'
        13. parametro → expression | ID