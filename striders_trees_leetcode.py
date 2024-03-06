#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 25 13:06:07 2023

@author: sola
"""


from collections import deque


class Node:
    def __init__(self,data):
        self.data = data
        self.left = None
        self.right = None
        #self.next = None
        self.hd = None
        
        
        
class Binary_Trees:
    
     def __init__(self):
        self.max_dia = 0
        self.maxi = 0
        self.res = []
        self.count  = 0
        self.prev = None
     def inorder_traversal(self,root):
        
        res = []
        if root:           
            res = res + self.inorder_traversal(root.left)
            res.append(root.data)
            res = res + self.inorder_traversal(root.right)
       
        return res
     
     def level_order_traversal(self,root):
#       
         q = []
         q.append(root)
         if root is None:
             return q
        
         
         while(q!= []):
            #size = len(q)
             #level = []
             print(q[0].data, end=" ")    
             node = q.pop(0) #taking the root to node
             #print(node)
             if (node.left)!=None:
                 q.append(node.left)
                 
             if node.right!=None:
                 q.append(node.right)
             
             #q.append(node)    
         #ans.append(q)  
                
         #return q
         
#*************Height/Max depth of a Binarytree  ****************************       
     def max_depth(self,root):
         
         
         if root is None:
             return 0
         left = self.max_depth(root.left)
         right = self.max_depth(root.right)
         
         return 1+max(left,right)
     
#**********Check if BT is balanced or not************************************        
     def check_balanced_tree(self,root):
         
         if root is None:
             return 0
         left = self.check_balanced_tree(root.left)
         right = self.check_balanced_tree(root.right)
         
         if left==-1:
             return -1
         if right ==-1:
             return -1
         
         if abs(left-right)>1:
             return -1
         
         return max(left,right)+1    

#****************Max Diameter of a BT*****************************************         
 #Diameter at given curve point = left height + right height
            
     def diameter_BT(self,root):
         
         if root is None:
             return 0
         left   = self.max_depth(root.left)
         right = self.max_depth(root.right)
         self.max_dia = max(self.max_dia,left+right)
         
         return self.max_dia
    
    
     def max_path_sum_helper(self,root):
         
         
         self.maxpath_down(root,self.maxi)
         #print(maxi)
         return self.maxi
        
        
     def  maxpath_down(self,root,maxi):
         
         if root == None:
             return 0
         
         left = max(0,self.maxpath_down(root.left,maxi))
         #print(left)#incase if there are any negative values for node values
         right = max(0,self.maxpath_down(root.right,maxi))
         #print(right)
         self.maxi = max(self.maxi,(left+right+root.data))
         #print(self.maxi)
         return max(left,right)+root.data #at subtree to choose the max path,we decide the max value of left/right
         
#****************Two trees identical or not***********************************
     def check_identical_BT(self,root1,root2):
         if root1==None or root2==None:
             return (root1==root2)
         
         if (root1.data == root2.data) and(self.check_identical_BT(root1.left,root2.left) 
         and self.check_identical_BT(root1.right,root2.right)):
             
             return True
         else:
             return False
    
#********************Zig zag level order traversal******************************
     def zig_zag_level_order_traversal(self,root):
         
         result = []
         if root==None:
             return result
         queue = []
         queue.append(root)
         lefttoright = True
         while (queue!=[]):
             
             size = len(queue)
             row = []
             for i in range(len(queue)):
                 node = queue[0]
                
                 queue.pop(0)
                 
                 #
                 index = i if (lefttoright) else (size-1-i)
                 print(index,node.data)
#                 row[index] = node.data
                 row.insert(index,node.data)
                 if (node.left):
                     queue.append(node.left)
                 if (node.right):
                     queue.append(node.right)
             lefttoright = not lefttoright
             result.append(row)
         return result           


#**************Boundary level Traversal in anti clockwise direction****************************************
#    Part 1: Left Boundary of the tree (excluding the leaf nodes).
    #Part 2: All the leaf nodes travelled in the left to right direction.
    #Part 3: Right Boundary of the tree (excluding the leaf nodes), traversed in the reverse direction.         

     def isleaf_node(self,root):
         if root.left==None and root.right==None:
             return True
         else:
             return False

     def addLeftBoundary(self,root,res):
         curr = root
         while(curr):
             if not (self.isleaf_node(curr)):
                 self.res.append(curr.data)
                 print(self.res)
             if (curr.left):
                 curr = curr.left
             else:
                 curr = curr.right
   
     def addRightBoundary(self,root,res):
         curr = root
         temp = []
         while(curr):
             if  not (self.isleaf_node(curr)):
                 temp.append(curr.data)
 
             if (curr.right):
                 curr = curr.right
             else:
                 curr = curr.left
  
         temp2 = list(reversed(temp))   
         print(temp2)
         self.res.extend(temp2)
        
     def addLeafBoundary(self,root,res):
         if self.isleaf_node(root):
             self.res.append(root.data)
             return
         else:
             if root.left:
                 self.addLeafBoundary(root.left,res)
             if root.right:
                 self.addLeafBoundary(root.right,res)
            
     def print_boundary_traversal(self,root):
         if root==None:
             return self.res

         if not (self.isleaf_node(root)):
             self.res.append(root.data)
            
         self.addLeftBoundary(root.left,self.res)    
         self.addLeafBoundary(root,self.res)
         self.addRightBoundary(root.right,self.res) 
         return self.res
#***************vertical_order_traversal****************************************     
     def vertical_order_traversal(self,root,hd,hash_map):
         if root==None:
             return
         if hd in hash_map.keys():        
             hash_map[hd].append(root.data)
         else:
             hash_map[hd] = [root.data]
         print(hash_map)
         self.vertical_order_traversal(root.left,hd-1,hash_map)
         self.vertical_order_traversal(root.right,hd+1,hash_map)
         
     def print_vertical_order_traversal(self,root):
         hd = 0
         hash_map = {}
         self.vertical_order_traversal(root,hd,hash_map)
         
         print("vertical order traversal:")
         #print(hash_map)
         for index,value in enumerate(sorted(hash_map)):
             for i in hash_map[value]:
                 print(i,end = " ")
             

#******************Top view***************************************************
     def top_view_BT(self,root):
         queue = []
         self.hd = 0
         hash_map = {}
         root.hd = self.hd
         
         queue.append(root)
         
         while(queue!=[]):
             node = queue[0]
             hd = node.hd
             queue.pop(0)
             if hd not in hash_map.keys():
                 hash_map[hd] = [node.data]
             if  node.left:
                 node.left.hd = hd-1
                 queue.append(node.left)
             if node.right:
                 node.right.hd = hd+1
                 queue.append(node.right)
         for i in sorted(hash_map):
             print(str(hash_map[i]),end = " ")
             
#********************Bottom view*********************************************
     def bottom_view(self,root):
         if (root==None):
             return
         self.hd = 0
         min_hd ,max_hd = 0,0
         hash_map = {}
         queue = []
         root.hd = self.hd
         queue.append(root)
         
         while(queue!=[]):
             curr_node = queue.pop(0)
             hd = curr_node.hd
             min_hd = min(hd,min_hd)
             max_hd = max(hd,max_hd)
             
             hash_map[hd] = curr_node.data
             
             if curr_node.left:
                curr_node.left.hd = hd-1
                queue.append(curr_node.left)
                
             if curr_node.right:
                curr_node.right.hd = hd+1
                queue.append(curr_node.right)
         for i in range(min_hd, max_hd+1):
             print(hash_map[i], end = ' ')


#***********Right view*******************************************************
     def right_view_BT(self,root,level,res):
         if root==None:
             return
         if (len(self.res)==level):
             self.res.append(root.data)
             
         self.right_view_BT(root.right,level+1,self.res)
         self.right_view_BT(root.left,level+1,self.res)
         
     def rightsideview_helper(self,root):
         self.res = []
         level = 0
         self.right_view_BT(root,level,self.res)  
         return self.res
     
     def left_view_BT(self,root,level,res):
         if root==None:
             return
         if (len(self.res)==level):
             self.res.append(root.data)
             
         self.left_view_BT(root.left,level+1,self.res)
         self.left_view_BT(root.right,level+1,self.res)
         
     def leftsideview_helper(self,root):
         self.res = []
         level = 0
         self.left_view_BT(root,level,self.res)  
         return self.res
        
#********Symmetric Binary Tree*************************************************
     def issymmetric_BT(self,root1,root2):
         if root1==None or root2==None:
             return root1==root2
         
         return ((root1.data == root2.data) and
         self.issymmetric_BT(root1.left,root2.right) and self.issymmetric_BT(root1.right,root2.left))
            
     def issymmetric_helper(self,root):
         if root==None:
             return True
         return self.issymmetric_BT(root.left,root.right)
         
            
            
#************Print Root to Node Path in a Binary Tree**************************                
     def root_node_path(self,root,x,res):
         if root==None:
             return False
         
         self.res.append(root.data)
             
         if root.data == x:
             return True
         
         if  (self.root_node_path(root.left,x,self.res)) or (self.root_node_path(root.right,x,self.res)):
             return True
         
         
         self.res.pop(-1)
         return False
        
     def _root_node_path_helper(self,root,x):
         self.res = []
         result = self.root_node_path(root,x,self.res)
         print(result)
         print(self.res)

#*******************Maximum width BT************************************************************  
     def maximim_width_BT(self,root):
         if root==None:
             return 0
         ans = 0
         queue = []
         queue.append({root:0})
         while(queue!=[]):
             size = len(queue)-1
             print(queue)
             curr_min = list(queue[0].values())[0]
             print(curr_min)
             leftmost,rightmost = 0,0
             for i in range(len(queue)):
                 cur_id = list(queue[0].values())[0] - curr_min
                 node = list(queue[0].keys())[0]
                 queue.pop(0)
                 if i==0:
                     leftmost = cur_id
                 if i == size-1:
                     rightmost = cur_id
                 if node.left:
                     queue.append({node.left:cur_id*2+1})
                 if node.right:
                     queue.append({node.right:cur_id*2+2})
             ans = max(ans,rightmost-leftmost+1)    
         return ans


#*****************************************************************************
#Check for children sum property
     def reorder(self,root):
         
         if root== None:
             return
         child = 0  # below code--if root.data is greater than sum of childres data
         if root.left:
             child += root.left.data
         if root.right:
             child += root.right.data
         if child < root.data:
             if root.left:
                 root.left.data = root.data
             elif root.right:
                 root.right.data = root.data
         self.reorder(root.left)
         self.reorder(root.right)
         
         total = 0 #below code if root.data is less than sum of childres data
         if root.left:
             total += root.left.data
         if root.right:
             total += root.right.data
         
         if total >= root.data:
                root.data = total
             
#*****************Count number of nodes in BT********************************
     def count_nodes_BT(self,root,count):
         
         if root==None:
             return 0
         self.count += 1
         self.count_nodes_BT(root.left,self.count)
         self.count_nodes_BT(root.right,self.count)
         
     
     def count_nodes_helper(self,root):
         count = self.count
         self.count_nodes_BT(root,count)
         print(self.count)
         
#another method to calculate number of nodes--using 2 power h-1,finding lh and rh,if both are same then 2^h-1,,
#else count each and every node by traversing
    
     def findleftheight(self,cur_node):
          if cur_node == None:
              return
          while(cur_node):
              height += 1
              cur_node = cur_node.left
          return (height)    
     
     def findrightheight(self,cur_node):
         if cur_node == None:
             return
         while(cur_node):
             height += 1
             cur_node = cur_node.right
         return (height) 
           
     def count_nodes(self,root):
         if root==None:
             return 0
         lh = self.findleftheight(root.left)
         rh = self.findrightheight(root.right)
         
         if (lh==rh):
             return (2^lh)-1
                   
         left_nodes = self.count_nodes(root.left)
         right_nodes = self.count_nodes(root.right)
        
         return (1+left_nodes+right_nodes)
        
#************Serialize and deserialize*****************************************
     def serialize_BT(self,root):
         if root == None:
             return " "
         queue = []
         string = []
         queue.append(root)
        
         while(queue!=[]):
             node = queue[0]
             
             queue.pop(0)
             if node==None:
                 string.append("#,")
             else:   
                 
                 string.append(str(node.data)+',')
             if node!=None:
                 queue.append(node.left)
            
                 queue.append(node.right)
         string2 = "".join(string)      
         return string2        
            
     def deserialize(self,string_data):
         if len(string_data)==0:
             return None
         global t
         t = 0
         split_list = string_data.split(',')
         #print(split_list)
         return self.deserialize_helper(split_list)
     
     def deserialize_helper(self,arr):
         global t
         
         if arr[t]=="#":
             return None
         root = Node(int(arr[t]))
         print(root.data)
         t += 1
         root.left = self.deserialize_helper(arr)
         root.right = self.deserialize_helper(arr)
         
         return root
     #just to print the data
     def inorder(self, root):
        if root:
            self.inorder(root.left)
            print(root.data, end=" ")
            self.inorder(root.right)


#************Flatten the Binary Tree to Linked list**************************
#Right ,Left,Root traversing       
     def flatten_BT_linkedlist(self,root,prev):
        if root==None:
             return
        self.flatten_BT_linkedlist(root.right,self.prev)
        self.flatten_BT_linkedlist(root.left,self.prev)
            
        root.right = self.prev
        root.left = None
        self.prev = root   
        
               
     def flatten_helper(self,root):
         
#         while(root.right!=None):
#             root = root.right
#         print(root.data)    
         self.flatten_BT_linkedlist(root,self.prev)
         while(root.right!=None):
             print(root.data)
             root = root.right
         print(root.data)    


#********second method using stacks**********************
     def flatten_BT_stacks(self,root):
         if root == None:
             return
         stack = []
         stack.append(root)
         while(stack!=[]):
             node = stack[-1]
             stack.pop(-1)
             if (node.right):
                 stack.append(node.right)
             if node.left:
                 stack.append(node.left)
             if stack!=[]:
                 node.right = stack[-1]
             node.left = None    

     def flatten_BT_stacks_helper(self,root):
         self.flatten_BT_stacks(root)
         while(root.right!=None):
             
             print(root.data)
             root = root.right
         print(root.data)    

#******************************************************************************#
#--------------------------------BINARY SEARCH TREES --------------------------#
#*************Search in a Binary search TTree*********************************
     def Search_BST(self,root,val):
         while ( root!=None and root.data !=val):
             if val < root.data:
                 root = root.left
             else:
                 root=root.right
         return root        

#**********************Ceil in a BST*******************************************
     def ceil_BST(self,root,key):
         ceil = -1
         if root==None:
             return
         while(root):
             if root.data == key:
                 ceil = root.data
                 return ceil
             
             if key < root.data:
                 ceil = root.data
                 root = root.left
             
             else:   
                 
                 root = root.right
         return ceil        

     def floor_BST(self,root,key):
         floor = -1
         if root==None:
             return
         while(root):
             if root.data == key:
                 floor = root.data
                 return floor
             if key > root.data:
                 floor = root.data
                 root = root.right
             else:
                
                 root=root.left
         return floor        

     def insert_Node_BST(self,root,val):
         if root==None:
             root = Node(val)
        
         return root   
         cur = root
         while(cur):
             if cur.data <= val:
                 if (cur.right)!=None:
                     cur = cur.right
                 else:
                     cur.right = Node(val)
                     break
             else:
                 if (cur.left)!=None:
                     cur = cur.left
                 else:
                     cur.left = Node(val)
                     break
                
         return root        
                    
#*****************Delete Node in BST*****************************************
     def delete_node_BST(self,root,key):
         if root == None:
             return None
         if root.data == key:
             return self.delete_node_BST_helper(root)
     
         dummy = root
        
         while(root!=None):
             if root.data >key:
                 if root.left !=None and root.left.data ==key:
                     root.left = self.delete_node_BST_helper(root.left)
                     break
                 else:
                     root = root.left
        
             else:
                 if root.right!=None and root.right.data==key:
                     root.right = self.delete_node_BST_helper(root.right)
                     break
                 else:
                     root= root.right
         return dummy
    
     def delete_node_BST_helper(self,root):
        
         if root.left==None:
             return root.right
         if root.right == None:
             return root.left
        
         rightchild = root.right
         lastrightchild = self.findlastright(root.left)
         lastrightchild.right = rightchild
         return root.left
    
     def findlastright(self,root):
         if root.right==None:
             return root
        
         return self.findlastright(self,root.right)
        
#***************LCA in BST***************************************************
     def LCA_BST(self,root,nodep,nodeq):
         if root==None:
             return None
         curr = root.data
        
         if curr < nodep.data and curr < nodeq.data:
             self.LCA_BST(root.right,nodep,nodeq)
         if curr > nodep.data and curr > nodeq.data:
             self.LCA_BST(root.left,nodep,nodeq)
         return root

#*****************Check if a BT is BST or not*********************************
     def check_BST_helper(self,root):
         maxi = float('inf')
         mini = float('inf')
         return self.check_BST(root,maxi,mini)
    
     def check_BST(self,root,maxi,mini):
         if root == None:
             return True
        
         if root.data <= mini and root.data >= maxi:
             return False
         return (self.check_BST(root.left,root.data,mini) and 
                 (self.check_BST(root.right,maxi,root.data)))
    


#*******************Kth smallest node in BST**********************************
     def Kth_smallest_BST_helper(self,root):
         global k 
         k = 3
         return self.Kth_smallest_BST(root)
     def Kth_smallest_BST(self,root):
         global k
         if root:                      
             self.inorder(root.left)
             k = k-1     
             if k==0:
                 return root.data
                 
             self.Kth_smallest_BST(root.right)
        

        
if __name__ == '__main__':
     
    # Let's create the Binary Tree shown in above diagram
#    root = Node(1)
#    root.left = Node(2)
#    root.right = Node(5)
#    root.left.left = Node(3)
#    root.left.right= Node(4)
#    #root.right.left = Node(4)
#    root.right.right = Node(6)
#    
#    root.right.right.left = Node(7)
   # root.left.left.right = Node(4)
#    root.left.right.left = Node(10)
#    root.left.right.right = Node(14)
    
#    
#    root.right.right.left.left = Node(10)
#    root.right.right.left.right = Node(11)
    
#    root = Node(20)
#    root.left = Node(8)
#    root.right = Node(22)
#    root.left.right = Node(4)
#    root.left.right.right = Node(5)
#    root.left.right.right.right = Node(6)
#    
##    root2 = Node(1)
#    root2.left = Node(2)
#    root2.right = Node(3)
##    root.left.left = Node(4)
##    root.left.right = Node(5)
##    root.left.left.left = Node(6)
#    root2.right.left = Node(15)
    #root2.right.right = Node(7)   
    root = Node(15)
    root.left = Node(10)
    root.right = Node(20)
    root.left.left = Node(8)
    root.left.right = Node(12)
    root.right.left = Node(16)
    root.right.right = Node(25)
 
    
    bt = Binary_Trees()
#    res = bt.inorder_traversal(root)
#    print(res)
   # bt.level_order_traversal(root)
    
#    depth = bt.max_depth(root)
#    print(depth)
#    
#    output = bt.check_balanced_tree(root)
#    print(output)     
#    
    
    
#    dia = bt.diameter_BT(root)
#    print(dia)
    
#    y = bt.max_path_sum_helper(root)
#    print(y)
    
   
#    check = bt.check_identical_BT(root1,root2)
#    print(check)

#    result = bt.zig_zag_level_order_traversal(root1)
#    print(result)

#    res = bt.print_boundary_traversal(root)
#    print(res)
    
#    bt.print_vertical_order_traversal(root) 
       
#    bt.top_view_BT(root)
    #bt.bottom_view(root)
#    result = bt.rightsideview_helper(root)
#    print(result)
#    result = bt.leftsideview_helper(root)
#    print(result)
#    result = bt.issymmetric_helper(root)
#    print(result)
    
   # bt._root_node_path_helper(root,13)
#    ans = bt.maximim_width_BT(root)
#    print(ans)
   
#    bt.count_nodes_helper(root)
#    string = bt.serialize_BT(root)
#    print(string)
#   
#string = input("enter the data")  
#string.split(',') 
    #string_data = '1,2,3,#,5,6,#,7,8'   
#    output = bt.deserialize(string)
#    bt.inorder(output)
    
    
    
    #bt.flatten_helper(root)
   # bt.flatten_BT_stacks_helper(root)
    output = bt.Kth_smallest_BST_helper(root)
    print(output)