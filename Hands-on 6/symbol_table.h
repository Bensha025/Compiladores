#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef enum {
    VAR_SYM,
    FUNC_SYM
} SymbolType;

typedef struct Symbol {
    char *name;
    SymbolType type;
    int param_count;
    struct Symbol *next;
} Symbol;

void init_global_table();
void enter_scope();
void exit_scope();
void insert_symbol(char *name, SymbolType type, int param_count);
Symbol *lookup(char *name);

#endif

