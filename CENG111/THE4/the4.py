def construct_forest(Defs):
    def split(Defs):
        stripped = [b.replace(" ", "") for b in Defs]
        #got rid of spaces
        
        #there is a class to split from equation and determine the functions name,operator used and the other terms in the right side of the equation
        class FunctionPart:
            def __init__(self, function):
                self.function = function

            def part(self):
                function_name, function_string = self.function.split("=")
                function_name = function_name.strip()
                if "+" in function_string:
                    function_parts = function_string.split("+")
                    operator = "+"
                elif "-" in function_string:
                    function_parts = function_string.split("-")
                    operator = "-"
                elif "*" in function_string:
                    function_parts = function_string.split("*")
                    operator = "*"
                elif "^" in function_string:
                    function_parts = function_string.split("^")
                    operator = "^"
                terms = [term.strip() for term in function_parts]
                term1, term2 = terms[0], terms[1]
                return function_name[0], term1, term2, operator
        #return them by putting them in a separate list and return the list
        results = []
        for x in stripped:
            f = FunctionPart(x)
            name, term1, term2, operator = f.part()
            results.append([name, operator, term1, term2])
        return results
    #get a variable with splitting
    new = split(Defs)
    funcinit=""
    #new function to put the functions which is inside another function
    def change(new):
        deleteindex=[]
        L=[]
        for x in range(101):
            x = str(x)
            L.append(x)
        while True:
            for i in range(len(new)):
                for j in range(len(new[i])):
                    #if it is x put in a list
                    if new[i][j]=="x":
                        new[i][j]=list("x")
                    #if it is a constant, put in a list
                    if new[i][j] in L:
                        new[i][j]=[new[i][j]]
                    #if function change it to what it was separately
                    if "(" in new[i][j]:
                        funcinit=new[i][j][0]
                        for x in range(len(new)):
                            for y in range(len(new[x])):
                                if funcinit == new[x][y] and i!=x:
                                    new[i][j] = new[x]
                                    #collect the indexes of functions we put in the other function to get rid of them later
                                    deleteindex.append(x)
                                    break
            if "(" not in str(new):
                break
        #getting rid of them here
        for i in sorted(list(set(deleteindex)), reverse=True):
            del new[i]
        return new
    #change the splitted function
    new2=change(new)
    return new2
