#include <string>
#include <vector>
#include <iostream>
#include <utility>
#include <algorithm>
using namespace std;

// do not add any other library.
// modify parts as directed by assignment text and comments here.

template <class T>
class BST {
private:
    // Define TreeNode for the second phase (Binary Search Tree)
    /* DO NOT CHANGE */
    struct TreeNode {
        std::string key;
        T data;
        TreeNode* left;
        TreeNode* right;
        TreeNode(const std::string &k, const T& value) : key(k), data(value), left(NULL), right(NULL) {}
        
    };

    TreeNode* root;


public: // Do not change.

    BST();
    ~BST();
    TreeNode* getRoot() { return root; }
    bool isEmpty() { return root == NULL; }

    BST& insert(const std::string key, const T& value);
    bool search(std::string value) const;
    void remove(std::string value);
    BST<T>* merge(BST<T>* bst);
    BST<T>* intersection(BST<T>* bst);
    std::vector<TreeNode> tree2vector(TreeNode* root);
    void print();
    
private:// you may add your own utility member functions here.

    void print(TreeNode* node, std::string indent, bool last, bool isLeftChild); // Do not change.
    void deleteTreeNode(TreeNode* node);
    void insertHelper(TreeNode* node ,const std::string key, const T& value);
    bool searchHelper(TreeNode* node ,std::string value) const;
    TreeNode* removeHelper(TreeNode* node, std::string key);
    void tree2vector(TreeNode* node, vector<TreeNode> &result);
};

    // Constructor
    template <class T>
    BST<T>::BST() : root(NULL) {}
    
    template <class T>
    void BST<T>::deleteTreeNode(TreeNode* node)
    {
        if(node)
        {
            deleteTreeNode(node->right);
            deleteTreeNode(node->left);
            delete node;
        }
    }

    // Destructor
    template <class T>
    BST<T>::~BST() {
    /* IMPLEMENT THIS */
        deleteTreeNode(root);
    }
    
    template<class T>
    void BST<T>::insertHelper(TreeNode* node ,const std::string key, const T& value)
    {
        int comp = 0;
        
        if(node)
        {
            comp = key.compare(node->key);
        }
        
        if(comp > 0)
        {
            if(!node->right)
            {
                node->right = new TreeNode(key, value);
            }
            else
            {
                this->insertHelper(node->right, key, value);
            }
        }
        else if(comp < 0)
        {
            if(!node->left)
            {
                node->left = new TreeNode(key, value);
            }
            else
            {
                this->insertHelper(node->left, key, value);
            }
        }
        else
        {
            return;
        }
    }

    // Insert function for BST.    
    template <class T>
    BST<T>& BST<T>::insert(const string key, const T& value) {
             /* IMPLEMENT THIS */
        if(!root)
        {
            root = new TreeNode(key, value);
        }
        else
        {
            this->insertHelper(root, key, value);
        }
          
        return *this;
    }
    
    template <class T>
    bool BST<T>::searchHelper(TreeNode* node ,std::string value) const
    {
        int comp = 0;
        
        if(!node)
        {
            return false;
        }
        
        comp = value.compare(node->key);
        
        if(comp == 0)
        {
            return true;
        }
        else if(comp > 0)
        {
            return this->searchHelper(node->right, value);
        }
        else if(comp < 0)
        {
            return this->searchHelper(node->left, value);
        }
    }
    
    // Search function for BST.
    template <class T>
    bool BST<T>::search(std::string value) const {
     /* IMPLEMENT THIS */
        return searchHelper(root, value);
    }
    
    template <class T>
    typename BST<T>::TreeNode* BST<T>::removeHelper(TreeNode* node, std::string key)
    {
        int comp = 0;

        if(node)
        {
            comp = key.compare(node->key);
        }

        if(!node)
        {
            return NULL;
        }
        else if(comp < 0)
        {
            node->left = this->removeHelper(node->left, key);
        }
        else if(comp > 0)
        {
            node->right = this->removeHelper(node->right, key);
        }
        else
        {
            if(node->left && node->right)
            {
                TreeNode* curr = node->right;
                
                while(curr && curr->left)
                {
                    curr = curr->left;
                }

                node->data = curr->data;
                node->key = curr->key;
                node->right = this->removeHelper(node->right, curr->key);
            }
            else
            {
                TreeNode* oldNode = node;
                if(node->left)
                {
                    node = node->left;
                }
                else
                {
                    node = node->right;
                }
                
                delete oldNode;
                return node;
            }
        }

        return node;
    }
    
    // Remove a node from BST for given key. If key not found, do not change anything.
    template <class T>
    void BST<T>::remove(std::string key) {
        /* IMPLEMENT THIS */
        root = this->removeHelper(root, key);
    }
    
    template <class T>
    void BST<T>::tree2vector(TreeNode* node, vector<TreeNode> &result)
    {
        if(!node)
        {
            return;
        }
        
        tree2vector(node->left, result);
        result.push_back(*node);
        tree2vector(node->right, result);
    }
    
    // A helper function for converting a BST into vector.
    template <class T>
    vector<typename BST<T>::TreeNode> BST<T>::tree2vector(TreeNode* root) {
        vector<TreeNode> result;
        vector<TreeNode>& resultRef = result;
        tree2vector(root, resultRef);
        return result;
    }
    
    // Merge two BST's and return merged BST.
    template <class T>
    BST<T>* BST<T>::merge(BST<T>* bst) {
    /* IMPLEMENT THIS */
        BST<T>* newBST = new BST<T>();
        vector<TreeNode> v1, v2, res;
        int i = 0, j = 0, comp;
        int start, end, middle;
        TreeNode* curr = root;
        
        v1 = this->tree2vector(this->getRoot());
        v2 = bst->tree2vector(bst->getRoot());
        
        if(v1.size() == 0 && v2.size() == 0)
        {
            return NULL;
        }
        
        while(i < v1.size() && j < v2.size())
        {
            comp = (v1[i].key).compare(v2[j].key);
            
            if(comp < 0)
            {
                res.push_back(v1[i]);
                i++;
            }
            else if(comp > 0)
            {
                res.push_back(v2[j]);
                j++;
            }
            else if(comp == 0)
            {
                res.push_back(v1[i]);
                i++;
                j++;
            }
        }
        
        while(i < v1.size())
        {
            res.push_back(v1[i]);
            i++;
        }
        
        while(j < v2.size())
        {
            res.push_back(v2[j]);
            j++;
        }
        
       for(int k = 0; k < res.size(); k++)
       {
           newBST->insert(res[k].key, res[k].data);
       }
        
        return newBST;
    }
        
    // Intersect two BST's and return new BST.
    template <class T>
    BST<T>* BST<T>::intersection(BST<T>* bst) {
    /* IMPLEMENT THIS */
        BST<T>* newBST = new BST<T>();
        vector<TreeNode> v1, v2, res;
        int i = 0, j = 0, comp;
        int start, end, middle;
        TreeNode* curr = root;
        
        v1 = this->tree2vector(this->getRoot());
        v2 = bst->tree2vector(bst->getRoot());
        
        if(v1.size() == 0 && v2.size() == 0)
        {
            return NULL;
        }
        
        while(i < v1.size() && j < v2.size())
        {
            comp = (v1[i].key).compare(v2[j].key);
            
            if(comp < 0)
            {
                i++;
            }
            else if(comp > 0)
            {
                j++;
            }
            else if(comp == 0)
            {
                res.push_back(v1[i]);
                i++;
                j++;
            }
        }
        
        for(int k = 0; k < res.size(); k++)
        {
            newBST->insert(res[k].key, res[k].data);
        }
        
        return newBST;
    }
    
    /* DO NOT CHANGE */
    template <class T>
    void BST<T>::print() {
        print(root, "", true, false);
    
    }
    
    /* DO NOT CHANGE */
    template <class T>
    void BST<T>::print(TreeNode* node, string indent, bool last, bool isLeftChild) {
        if (node != NULL) {
            cout << node->key << endl;
            print(node->left, indent, false, true);
            print(node->right, indent, true, false);
        }
    
    }