template<class T>
    void BST<T>::insertHelper(TreeNode* node ,const std::string key, const T& value)
    {
       if(!node){
        return;
       }
       if(node->key > key){
        insertHelper(node->left, key, value);
       }
       else if(node->key < key){
        insertHelper(node->right, key, value);
       }
       else if(node->key = key){
        return;
       }
    
    }

template <class T>
    BST<T>& BST<T>::insert(const string key, const T& value) {
    if(root=NULL){
        root= new TreeNode(key,value);
        return root;
    }
    else{
        return insertHelper(root,key,value);
    }
    }

template <class T>
    bool BST<T>::searchHelper(TreeNode* node ,std::string value) const
    {
        if(node=NULL){
            return false;
        }
        else if(
            
        )
    }