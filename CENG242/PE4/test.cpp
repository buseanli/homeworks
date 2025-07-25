#include <iostream>
#include <fstream>

#include "the4.h"

std::vector<AncientScroll> readInputFromFile(const char inp_file[]){
    std::ifstream infile (inp_file);
    std::vector<AncientScroll> input_vector;
    if(!infile.is_open()){
        std::cout << "Input file cannot be opened" << std::endl;
        std::cout << "File writer: " << inp_file << std::endl;
    }
    else{
        int number_of_input;
        infile >> number_of_input;
        while(number_of_input--){
            int var1;
            std::string var2, var3;
            infile >> var1 >> var2 >> var3;
            AncientScroll currentScroll = {var1, var2, var3};
            input_vector.push_back(currentScroll);
        }
    }
    return input_vector;
}

void printVector(const std::vector<int>& idList) {
    for(auto id : idList)
        std::cout << id << " ";
    std::cout << std::endl;
}

int main() {
    char inp_file[] = "sample_input.txt";
    std::vector<AncientScroll> inputVector = readInputFromFile(inp_file);
    std::cout << "Ancient Scrolls:" << std::endl;
    for(auto& scroll : inputVector)
        std::cout << std::string(scroll) << std::endl;
    ArchivistMachine machine(inputVector);
    std::cout << std::string(machine) << std::endl;

    ArchivistMachine copyMachine(machine);
    std::cout << std::string(machine) << std::endl;
    std::cout << std::string(copyMachine) << std::endl;

    AncientScroll newScroll = {1, "The_Prison_Notebooks", "Gramsci"};
    machine << newScroll;
    std::cout << std::string(machine) << std::endl;
    AncientScroll existingScroll = machine[100];
    std::cout << std::string(existingScroll) << std::endl;
    machine >> newScroll;
    std::cout << std::string(newScroll) << std::endl;
    std::cout << std::string(machine) << std::endl;
    printVector(machine("inorder"));

    ArchivistMachine emptyMachine;
    std::cout << (std::string)emptyMachine << std::endl;
    return 0;
}
