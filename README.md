### 01_function_normaliza.sql
defines a utility function `normaliza_texto(txt TEXT)`:
- returns the text in uppercase, trimmed of leading/trailing spaces.
- returns `"DESCONOCIDO"` if the input is `NULL`.  
useful as a simple text normalization helper.

### 02_trigger_salario.sql
add prevents inserting or updating an employee with a salary lower than 1000.
- if the rule is violated, raises a custom exception.  
this enforces basic business rules at the database level.

### 03_function_fibonacci.sql
implements a pure function `fibonacci(n INT)`:
- returns the nth fibonacci number using a `FOR` loop.  
- handles base cases (`0`, `1`) and raises an exception for negative input.  
this shows how control flow and variables work in plpgsql.

### 04_trigger_auditoria.sql
auditing trigger on the `productos` table:
- tracks changes to **price** and **stock**.  
- inserts records into `productos_audit` with old/new values, the field changed, and a timestamp.  
- uses `IF ... ELSIF ...` to handle “price only”, “stock only”, or “both”.

### 05_function_procesa_facturas.sql
function `procesa_facturas()` with exception handling:
- iterates over all invoices in the `facturas` table.  
- calculates totals (`cantidad * precio_unitario`).  
- if invalid data is found (`precio_unitario = 0` or `cantidad < 0`), logs the error into `errores_log` and continues.  
- returns the accumulated total of valid invoices.

### Some references and documentation
- postgresql documentation:  
  - [plpgsql](https://www.postgresql.org/docs/current/plpgsql.html)  
  - [triggers](https://www.postgresql.org/docs/current/triggers.html)  
- stack overflow – [postgre questions](https://stackoverflow.com/questions/tagged/postgresql) 