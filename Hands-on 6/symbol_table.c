#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

typedef struct Scope {
    Symbol *symbols;
    struct Scope *next;
} Scope;

Scope *global_scope = NULL;

/* -------------------- Manejo de scopes -------------------- */

void init_global_table() {
    global_scope = NULL;
}

void enter_scope() {
    Scope *s = (Scope *)malloc(sizeof(Scope));
    s->symbols = NULL;
    s->next = global_scope;
    global_scope = s;
}

void exit_scope() {
    Scope *s = global_scope;
    Symbol *sym = s->symbols;

    while (sym) {
        Symbol *tmp = sym;
        sym = sym->next;
        free(tmp);
    }

    global_scope = global_scope->next;
    free(s);
}

/* -------------------- Insertar símbolo -------------------- */

void insert_symbol(char *name, SymbolType type, int param_count) {

    if (lookup(name)) {
        printf("? Error semántico: redeclaración de '%s'\n", name);
        return;
    }

    Symbol *sym = (Symbol *)malloc(sizeof(Symbol));
    sym->name = strdup(name);
    sym->type = type;
    sym->param_count = param_count;
    sym->next = global_scope->symbols;

    global_scope->symbols = sym;
}

/* -------------------- Buscar símbolo -------------------- */

Symbol *lookup(char *name) {
    Scope *s = global_scope;
    while (s) {
        Symbol *sym = s->symbols;
        while (sym) {
            if (strcmp(sym->name, name) == 0)
                return sym;
            sym = sym->next;
        }
        s = s->next;
    }
    return NULL;
}

