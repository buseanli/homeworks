#include <iostream>
#include <string>
#include <vector>
#include <utility>
using namespace std;


template <class T>
class Trie {    
private:
    // Define TrieNode for the first phase (Trie)
    /* DO NOT CHANGE */
    struct TrieNode {
        static const int ALPHABET_SIZE = 128;
        TrieNode* children[ALPHABET_SIZE];
        char keyChar;
        bool isEndOfKey;
        T* data;

        TrieNode(char c) : keyChar(c), isEndOfKey(false), data(NULL) {

                for (int i = 0; i< ALPHABET_SIZE; i++) {
                children[i] = NULL;
                
            }
            
            }
    };

    TrieNode* root;

public: // Do not change.

    Trie(); 
    ~Trie();
    
    Trie& insert(const string& username); 
    void remove(std::string username);
    T* search(std::string username); 
    void findStartingWith(std::string prefix, std::vector<T*> &results); 
    void wildcardSearch(const std::string &wildcardKey, std::vector<T*> &results); 
    void print(); 

private: // you may add your own utility member functions here.
    void print(const std::string& primaryKey); // Do not change this line.
    void printTrie(TrieNode* node, const std::string& currentKey); // Do not change this line.
    void deleteTrieNode(TrieNode* node);
    void findStartingWithHelper(TrieNode* start, vector<T*> &results);
    void wildcardSearchHelper(TrieNode* node, const std::string& wildcardKey, std::vector<T*>& results);
    
};
/* DO NOT CHANGE */
template <class T>
Trie<T>::Trie() : root(new TrieNode('\0')) {}

template <class T>
void Trie<T>::deleteTrieNode(TrieNode* node)
{

    if(node)
    {
        for(int i = 0; i < 128; i++)
        {
            this->deleteTrieNode(node->children[i]);
        }
        
        if(node->data)
        {
            delete node->data;
        }
        
        delete node;
    }
}

template <class T>
Trie<T>::~Trie() {
    /* IMPLEMENT THIS */
    this->deleteTrieNode(root);
}

template <class T>
Trie<T>& Trie<T>::insert(const string& key) {
    /* IMPLEMENT THIS */
    TrieNode *curr = root;
    int index;
    
    for(int i = 0; i < key.length(); i++)
    {
        index = (int)key[i];
        if(!curr->children[index])
        {
            curr->children[index] = new TrieNode(key[i]);
        }
        
        if(i == key.length() - 1)
        {
            curr->children[index]->isEndOfKey = true;
            curr->children[index]->data = new T(key);
        }

        curr = curr->children[index];
    }
    
    return *this;
}

template <class T>
T* Trie<T>::search(std::string username) {
    /* IMPLEMENT THIS */
    TrieNode *curr = root;
    int index = 0;
    
    for(int i = 0; i < username.length(); i++)
    {
        index = (int)username[i];
        
        if(!curr->children[index])
        {
            return NULL;
        }
        else
        {
            if(i == username.length() - 1 && curr->children[index]->isEndOfKey)
            {
                return curr->children[index]->data;
            }
            
            curr = curr->children[index];
        }
    }

    return NULL;
}

template <class T>
void Trie<T>::remove(std::string username) {
    /* IMPLEMENT THIS */
    TrieNode *curr = root;
    int index = 0;
    
    if(!curr)
    {
        return;
    }
    
    for(int i = 0; i < username.length(); i++)
    {
        index = (int)username[i];
        
        if(!curr->children[index])
        {
            return;
        }
        else
        {
            if(i == username.length() - 1)
            {
                curr->children[index]->isEndOfKey = false;
            }
            
            curr = curr->children[index];
        }
    }
}

template <class T>
void Trie<T>::findStartingWithHelper(TrieNode* start, vector<T*> &results)
{
    if(!start)
    {
        return;
    }

    if(start->isEndOfKey)
    {
        results.push_back(start->data);
    }

    for(int i = 0; i < 128; i++)
    {
        findStartingWithHelper(start->children[i], results);
    }
}

template <class T>
void Trie<T>::findStartingWith(string prefix,vector<T*> &results) {
/* IMPLEMENT THIS */
    TrieNode *curr = root;

    int index;
    
    for(int i = 0; i < prefix.length(); i++)
    {
        index = prefix[i];
        
        if(curr->children[index])
        {
            if(i == prefix.length() - 1)
            {
                if(curr->children[index]->isEndOfKey)
                {
                    results.push_back(curr->data);
                }
                this->findStartingWithHelper(curr->children[index], results);
            }
            curr = curr->children[index];
        }
        else
        {
            return;
        }
    }
}

template <class T>
void Trie<T>::wildcardSearchHelper(TrieNode* node, const std::string& wildcardKey, std::vector<T*>& results)
{
    int size = wildcardKey.length();
    
    if(!node)
    {
        return;
    }
    
    if(size == 0 && node->isEndOfKey)
    {
        results.push_back(node->data);
    }
    
    if(wildcardKey[0] == '?')
    {
        for(int i = 0; i < 128; i++)
        {
            if(node->children[i])
            {
                wildcardSearchHelper(node->children[i], wildcardKey.substr(1, size - 1), results);
            }
        }
    }
    else if(wildcardKey[0] == '*')
    {
        for(int i = 0; i < 128; i++)
        {
            if(node->children[i])
            {
                wildcardSearchHelper(node->children[i], wildcardKey.substr(1, size - 1), results);
                wildcardSearchHelper(node->children[i], wildcardKey, results);
            }
        }
    }
    else
    {
        int index = (int)wildcardKey[0];
        if(node->children[index])
        {
            wildcardSearchHelper(node->children[index], wildcardKey.substr(1, size - 1), results);
        }
    }
}

template <class T>
void Trie<T>::wildcardSearch(const std::string &wildcardKey, std::vector<T*> &results) {
/* IMPLEMENT THIS */
    this->wildcardSearchHelper(root, wildcardKey, results);
}

/* DO NOT CHANGE */
template<class T>
void Trie<T>::print() {
    print("");
}
/* DO NOT CHANGE */
template <class T>
void Trie<T>::print(const std::string& primaryKey) {
    if (primaryKey.empty()) {
        // Print the entire tree.
        printTrie(root, "");
    } else {
        // Print specific keys.
        TrieNode* primaryNode = root;
        for (int i = 0; i < primaryKey.length(); i++) {
            
            int index = primaryKey[i];
            if (!primaryNode->children[index]) {
                std::cout << "{}" << std::endl; // Primary key not found, nothing to print.
                return ;
            }
            primaryNode = primaryNode->children[index];
        }

        }
    }
/* DO NOT CHANGE */
template <class T>
void Trie<T>::printTrie(TrieNode* node, const std::string& currentKey) {
    if (!node) {
        return;
    }
    if (node->isEndOfKey) {
        std::cout << currentKey <<std::endl;
        std::cout << "Watched Movies:" << std::endl;
        if(node->data) {
            node->data->printMovies();
        }
    }
    for (int i = 0; i < 128; ++i) {
        if (node->children[i]) {
            printTrie(node->children[i], currentKey + static_cast<char>(i));
        }
    }
}