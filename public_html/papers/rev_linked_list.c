#include <stdio.h>
#include <stdlib.h>


struct NODE
{
    int x;
    struct NODE* next;
};


int main()
{
    struct NODE *root, *temp_i, *prev, *t, *temp;
    int i, size;
    
    // enter size
    printf("Enter size of linked list: ");
    scanf("%d", &size);


    // allocate memory for root
    root = (struct NODE *) malloc(sizeof(struct NODE));
    if(root == NULL)
    {
        printf("out of memory!\n"); 
        return 0;
    }
    root->next = NULL;
     
    // create a linked list of "size"
    temp_i = root;
    for(i = 0; i < size-1; i++)
    {
    
        temp_i->next = (struct NODE *)(malloc(sizeof(struct NODE)));
        temp_i->x = rand()%11+1;
        temp_i = temp_i->next;
    }
    temp_i->next = NULL;

    // print linked list
    temp_i = root;
    do
    {
        printf("%d ",temp_i->x);
        temp_i = temp_i->next;
    }while(temp_i != NULL);
    printf("\n");
        

    // reverse
    prev = root;
    t = root;
    while(1)
    {
        temp = t->next;
        if(t->next == NULL)
        {
            t->next == prev;
            root == t;
            break;
        }
        if(t == root)
            t->next == NULL;
        else
            t->next = prev;
        prev = t;
        t = temp;
             
    }

    // print linked list
    temp_i = root;
    do
    {
        printf("%d ",temp_i->x);
        temp_i = temp_i->next;
    }while(temp_i != NULL);
    printf("\n");
 
    return 0;
}
