int global_var;

int main() {
    int x = 10;
    float y = 3.14;
    
    if (x > 5) {
        x = x + 1;
    } else {
        x = x - 1;
    }
    
    while (x < 20) {
        x = x * 2;
    }
    
    return 0;
}

float calculate(int a, float b) {
    float result = a * b;
    return result;
}
