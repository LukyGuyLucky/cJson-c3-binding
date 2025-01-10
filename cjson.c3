/*
  Copyright (c) 2009 Dave Gamble
 
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
 
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
 
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
*/
module cjson;

/* Cjson Types: */
int cJson_False =0;
int cJson_True =1;
int cJson_NULL =2;
int cJson_Number =3;
int cJson_String =4;
int cJson_Array =5;
int cJson_Object =6;
	
int cJson_IsReference =256;
int cJson_StringIsConst =512;



/* The Cjson structure: */
struct Cjson {
	Cjson *next;
    Cjson *prev;	/* next/prev allow you to walk array/object chains. Alternatively, use GetArraySize/GetArrayItem/GetObjectItem */
	Cjson *child;		/* An array or object item will have a child pointer pointing to a chain of the items in the array/object. */

	int type;					/* The type of the item, as above. */

	ZString valuestring;			/* The item's string, if type==Cjson_String */
	int valueint;				/* The item's number, if type==Cjson_Number */
	double valuedouble;			/* The item's number, if type==Cjson_Number */

	ZString string;				/* The item's name string, if this item is the child of, or is in the list of subitems of an object. */
} 
def Malloc_fn =fn void(usz sz);
def Free_fn=fn void(void* ptr);
struct Cjson_Hooks {
      //void *(*malloc_fn)(size_t sz);
      Malloc_fn* malloc_fn;
      //void (*free_fn)(void *ptr);
      Free_fn* free_fn;
} 

/* Supply malloc, realloc and free functions to Cjson */
extern fn void initHooks(Cjson_Hooks* hooks) @extern("cJSON_Hooks");


/* Supply a block of JSON, and this returns a Cjson object you can interrogate. Call Cjson_Delete when finished. */
extern fn Cjson *parse(ZString value) @extern("cJSON_Parse");
/* Render a Cjson entity to text for transfer/storage. Free the char* when finished. */
extern fn ZString print(Cjson *item) @extern("cJSON_Print");
/* Render a Cjson entity to text for transfer/storage without any formatting. Free the char* when finished. */
extern fn ZString printUnformatted(Cjson *item) @extern("cJSON_PrintUnformatted");
/* Render a Cjson entity to text using a buffered strategy. prebuffer is a guess at the final size. guessing well reduces reallocation. fmt=0 gives unformatted, =1 gives formatted */
extern fn ZString printBuffered(Cjson *item,int prebuffer,int fmt) @extern("cJSON_PrintBuffered");
/* Delete a Cjson entity and all subentities. */
extern fn void   delete(Cjson *c) @extern("cJSON_Delete");

/* Returns the number of items in an array (or object). */
extern fn int	  getArraySize(Cjson *array) @extern("cJSON_GetArraySize");
/* Retrieve item number "item" from array "array". Returns NULL if unsuccessful. */
extern fn Cjson *getArrayItem(Cjson *array,int item) @extern("cJSON_GetArrayItem");
/* Get item "string" from object. Case insensitive. */
extern fn Cjson *getObjectItem(Cjson *obj,ZString string) @extern("cJSON_GetObjectItem");

/* For analysing failed parses. This returns a pointer to the parse error. You'll probably need to look a few chars back to make sense of it. Defined when Cjson_Parse() returns 0. 0 when Cjson_Parse() succeeds. */
extern fn ZString getErrorPtr() @extern("cJSON_GetErrorPtr");
	
/* These calls create a Cjson item of the appropriate type. */
extern fn Cjson *createNull() @extern("cJSON_CreateNull");
extern fn Cjson *createTrue() @extern("cJSON_CreateTrue");
extern fn Cjson *createFalse() @extern("cJSON_CreateFalse");
extern fn Cjson *createBool(int b) @extern("cJSON_CreateBool");
extern fn Cjson *createNumber(double num) @extern("cJSON_CreateNumber");
extern fn Cjson *createString(ZString string) @extern("cJSON_CreateString");
extern fn Cjson *createArray() @extern("cJSON_CreateArray");
extern fn Cjson *createObject() @extern("cJSON_CreateObject");

/* These utilities create an Array of count items. */
extern fn Cjson *createIntArray(int *numbers,int count) @extern("cJSON_CreateIntArray");
extern fn Cjson *createFloatArray(float *numbers,int count) @extern("cJSON_CreateFloatArray");
extern fn Cjson *createDoubleArray(double *numbers,int count) @extern("cJSON_CreateDoubleArray");
extern fn Cjson *createStringArray(char **strings,int count) @extern("cJSON_CreateStringArray");

/* Append item to the specified array/object. */
extern fn void  addItemToArray(Cjson *array, Cjson *item) @extern("cJSON_AddItemToArray");
extern fn void	addItemToObject(Cjson *object,ZString string,Cjson *item) @extern("cJSON_AddItemToObject");
extern fn void	addItemToObjectCS(Cjson *object,ZString string,Cjson *item) @extern("cJSON_AddItemToObjectCS");	/* Use this when string is definitely const (i.e. a literal, or as good as), and will definitely survive the Cjson object */
/* Append reference to item to the specified array/object. Use this when you want to add an existing Cjson to a new Cjson, but don't want to corrupt your existing Cjson. */
extern fn void  addItemReferenceToArray(Cjson *array, Cjson *item) @extern("cJSON_AddItemReferenceToArray");
extern fn void	addItemReferenceToObject(Cjson *object,ZString string,Cjson *item) @extern("cJSON_AddItemReferenceToObject");

/* Remove/Detatch items from Arrays/Objects. */
extern fn Cjson *detachItemFromArray(Cjson *array,int which) @extern("cJSON_DetachItemFromArray");
extern fn void   deleteItemFromArray(Cjson *array,int which) @extern("cJSON_DeleteItemFromArray");
extern fn Cjson *detachItemFromObject(Cjson *object,ZString string) @extern("cJSON_DetachItemFromObject");
extern fn void   deleteItemFromObject(Cjson *object,ZString string) @extern("cJSON_DeleteItemFromObject");
	
/* Update array items. */
extern fn void insertItemInArray(Cjson *array,int which,Cjson *newitem) @extern("cJSON_InsertItemInArray");	/* Shifts pre-existing items to the right. */
extern fn void replaceItemInArray(Cjson *array,int which,Cjson *newitem) @extern("cJSON_ReplaceItemInArray");
extern fn void replaceItemInObject(Cjson *object,ZString string,Cjson *newitem) @extern("cJSON_ReplaceItemInObject");

/* Duplicate a Cjson item */
extern fn Cjson *duplicate(Cjson *item,int recurse) @extern("cJSON_Duplicate");
/* Duplicate will create a new, identical Cjson item to the one you pass, in new memory that will
need to be released. With recurse!=0, it will duplicate any children connected to the item.
The item->next and ->prev pointers are always zero on return from Duplicate. */

/* ParseWithOpts allows you to require (and check) that the JSON is null terminated, and to retrieve the pointer to the final byte parsed. */
extern fn Cjson *parseWithOpts(ZString value,ZString[] return_parse_end,int require_null_terminated) @extern("cJSON_ParseWithOpts");

extern fn void minify(ZString json) @extern("cJSON_Minify");

/* Macros for creating things quickly. */
macro addNullToObject(obj,name)	=>	addItemToObject(obj, (ZString)name, createNull());
macro addTrueToObject(obj,name)	=>	addItemToObject(obj, (ZString)name, createTrue());
macro addFalseToObject(obj,name)	=>	addItemToObject(obj, (ZString)name, createFalse());
macro addBoolToObject(obj,name,b)	=>  addItemToObject(obj, (ZString)name, createBool(b));
macro addNumberToObject(obj,name,n)=>	addItemToObject(obj, (ZString)name, createNumber(n));
macro addStringToObject(obj,name,s)=>	addItemToObject(obj, (ZString)name,createString((ZString)s));

/* When assigning an integer value, it needs to be propagated to valuedouble too. */
macro setIntValue(obj,val)		=>	obj?obj.valueint=obj.valuedouble=val:val;
macro setNumberValue(obj,val)	=>	obj?obj.valueint=obj.valuedouble=val:val;

