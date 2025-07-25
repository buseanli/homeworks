#include "the4.h"
static int ctr = 0;
ArchivistMachine::ArchivistMachine(){
    root = nullptr;
    ctr++;
    machineId = ctr;
}

ArchivistMachine::ArchivistMachine(const std::vector<AncientScroll>& initialElements){
    root = nullptr;
    ctr++;
    machineId = ctr;
    for (int i = 0; i < initialElements.size(); i++){
         root = insertNode(root, initialElements[i]);
    }
}

MachineNode* ArchivistMachine::insertNode(MachineNode* node, const AncientScroll& scroll) {
    if (node == nullptr){
        return new MachineNode(scroll);
    }
    if (scroll.scrollId < node->getScroll().scrollId) {
        node->leftChild = insertNode(node->leftChild, scroll);
    }
    else if (scroll.scrollId > node->getScroll().scrollId) {
        node->rightChild = insertNode(node->rightChild, scroll);
    }
    return node;
}

ArchivistMachine::ArchivistMachine(const ArchivistMachine& existingMachine){
    ctr++;
    machineId = ctr;
    root = copyTree(existingMachine.root);
}

void ArchivistMachine::deleteTree(MachineNode* node) {
    if (node== nullptr){
        return;
    }
    deleteTree(node->leftChild);
    deleteTree(node->rightChild);
    delete node;
}

ArchivistMachine::~ArchivistMachine(){
    deleteTree(root);
    root = nullptr;
}

void ArchivistMachine::operator<<(const AncientScroll& scroll){
        root=insertNode(root, scroll);
    }

void ArchivistMachine::operator>>(AncientScroll& scroll){
        if (root == nullptr) {
        scroll = {-1, "", ""};
        return;
    }
    scroll = root->getScroll();
    root = removeRootNode(root);

}

AncientScroll ArchivistMachine::operator[](int id) const{
    MachineNode* curr = root;
    while (curr) {
        if (id == curr->getScroll().scrollId) {
           return curr->getScroll();

        } else if (id < curr->getScroll().scrollId) {
            curr = curr->leftChild;
        } else {
            curr = curr->rightChild;
        }
    }
    return {-1, "", ""};
}

void ArchivistMachine::traversal(MachineNode* node,
                                 const std::string& type,
                                 std::vector<int>& lst) const {
    if (!node) return;
    if (type == "preorder") {
        lst.push_back(node->getScroll().scrollId);
        traversal(node->leftChild,  type, lst);
        traversal(node->rightChild, type, lst);
    }
    else if (type == "inorder") {
        traversal(node->leftChild,  type, lst);
        lst.push_back(node->getScroll().scrollId);
        traversal(node->rightChild, type, lst);
    }
    else if (type == "postorder") {
        traversal(node->leftChild,  type, lst);
        traversal(node->rightChild, type, lst);
        lst.push_back(node->getScroll().scrollId);
    }
}
std::vector<int> ArchivistMachine::operator()(std::string type) const{
    std::vector<int> lst;
    traversal(root, type, lst);
    return lst;
}

MachineNode* ArchivistMachine::copyTree(const MachineNode* node) {
        if (node == nullptr){
            return nullptr;
        }
        MachineNode* node2 = new MachineNode(node->getScroll());
        node2->leftChild = copyTree(node->leftChild);
        node2->rightChild = copyTree(node->rightChild);
    
        return node2;
}

MachineNode* ArchivistMachine::removeRootNode(MachineNode* node) {
    if (node == nullptr){
            return nullptr;
        }
    if (node->leftChild == nullptr && node->rightChild == nullptr) {
        delete node;
        return nullptr;
    }
    if (node->leftChild == nullptr) {
        MachineNode* tmp = node->rightChild;
        delete node;
        return tmp;
    }
    if (node->rightChild == nullptr) {
        MachineNode* tmp = node->leftChild;
        delete node;
        return tmp;
    }
    MachineNode* parent = node;
    MachineNode* temp = node->rightChild;
    while (temp->leftChild) {
        parent = temp;
        temp = temp->leftChild;
    }
    node->setScroll(temp->getScroll());
    if (parent->leftChild == temp) {
        parent->leftChild = removeRootNode(temp);
    } else {
        parent->rightChild = removeRootNode(temp);
    }

    return node;
}

// You can define more private/public methods