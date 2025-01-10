/*
    Converted from cJson original example
    use at your own risk.
*/
module test_0;

import libc;

fn void main()
{
    test1();
    test2();
}

fn void test1()
{
    //ZString text1=`{\n"name": "Jack (\"Bee\") Nimble", \n"format": {"type":       "rect", \n\"width":      1920, \n"height":     1080, \n"interlace":  false,"frame rate": 24\n}\n}`;	
    ZString text1="{\n\"name\": \"Jack (\\\"Bee\\\") Nimble\", \n\"format\": {\"type\":       \"rect\", \n\"width\":      1920, \n\"height\":     1080, \n\"interlace\":  false,\"frame rate\": 24\n}\n}";	
    
    
    doit(text1);
    
    dofile("tests/test1");
    dofile("tests/test2");
    dofile("tests/test3");
    dofile("tests/test4");
    dofile("tests/test5");
    
   
    
   
}

fn void doit(ZString text)
{
    ZString out;
    Cjson* json;
    
    json=cJSON_Parse(text);
    
    if(!json)
    {
        libc::printf("Error before:[%s]\n",cJSON_GetErrorPtr());
    }
    else
    {
        out=cJSON_Print(json);
        cJSON_Delete(json);
        libc::printf("%s\n",out);
        libc::free(out);
    }

}
fn void dofile(String filename)
{
    CFile f;
    long len;
    ZString data;
    
    f=libc::fopen(filename.zstr_copy(),"rb");
    libc::fseek(f,0,libc::SEEK_END);
    len=libc::ftell(f);
    libc::fseek(f,0,libc::SEEK_SET);
    data=(ZString)malloc(len+1);
    libc::fread(data,1,len,f);
    libc::fclose(f);
    doit(data);
    libc::free(data);
}

struct Record
{
    ZString precision;
    double lat;
    double lon;
    ZString address;
    ZString city;
    ZString state;
    ZString zip;
    ZString country;
}
fn void create_object()
{
    Cjson* root;
    Cjson* fmt;
    Cjson* img;
    Cjson* thm;
    Cjson* fld;
    
    ZString out;
    int i;
    
    ZString* strings=&&ZString[*]{"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
    
    int[3][3] numbers={{0,-1,0},{1,0,0},{0,0,1}};

    int[4] ids={116,943,234,38793};
    
    Record[2] fields={
        {"zip",37.7668,-1.223959e+2,"","San Francisco","CA","94107","US"},
        {"zip",37.371991,-1.22026e+2,"","SunnyVale","CA","94085","US"}
    };
    
    root=cJSON_CreateObject();
    cJSON_AddItemToObject(root,"name",cJSON_CreateString("Jack (\"Bee\") Nimble"));
    cJSON_AddItemToObject(root,"format",fmt=cJSON_CreateObject());
    cJSON_AddStringToObject(fmt,"type",              (ZString)"rect");
    cJSON_AddNumberToObject(fmt,"width",            1920);
    cJSON_AddNumberToObject(fmt,"height",           1080);
    cJSON_AddFalseToObject(fmt,"interface");
    cJSON_AddNumberToObject(fmt,"frame rate",       24);
    
    out=cJSON_Print(root);
    cJSON_Delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
    root=cJSON_CreateStringArray(strings,7);
    out=cJSON_Print(root);
    cJSON_Delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
    root=cJSON_CreateArray();
    for(i=0;i<3;i++)
    {
        cJSON_AddItemToArray(root,cJSON_CreateIntArray(&numbers[i],3));
    }
    
    out=cJSON_Print(root);
    cJSON_Delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
    root=cJSON_CreateObject();
    cJSON_AddItemToObject(root,"Image",img=cJSON_CreateObject());
    cJSON_AddNumberToObject(img,"Width",800);
    cJSON_AddNumberToObject(img,"Height",600);
    cJSON_AddStringToObject(img,"Title","View from 15th Floor");
    cJSON_AddItemToObject(img,"Thumbnail",thm=cJSON_CreateObject());
    cJSON_AddStringToObject(thm,"Url",(ZString)"http:/*www.example.com/image/481989943");
    cJSON_AddNumberToObject(thm,"Height",125);
    cJSON_AddStringToObject(thm,"Width","100");
    cJSON_AddItemToObject(thm,"IDs",cJSON_CreateIntArray(&ids,4));
    
    out=cJSON_Print(root);
    cJSON_Delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
    root=cJSON_CreateArray();
    for(i=0;i<2;i++)
    {
        cJSON_AddItemToArray(root,fld=cJSON_CreateObject());
        cJSON_AddStringToObject(fld,"precision",fields[i].precision);
        cJSON_AddNumberToObject(fld,"Latitude",fields[i].lat);
        cJSON_AddNumberToObject(fld,"longtitude",fields[i].lon);
        cJSON_AddStringToObject(fld,"Address",fields[i].address);
        cJSON_AddStringToObject(fld,"Citu",fields[i].city);
        cJSON_AddStringToObject(fld,"State",fields[i].state);
        cJSON_AddStringToObject(fld,"Zip",fields[i].zip);
        cJSON_AddStringToObject(fld,"Country",fields[i].country);
    }
    out=cJSON_Print(root);
    cJSON_Delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
}
fn void test2()
{
    create_object();
}

/* 
    cjson.h to cjson.c3 binding keeping the original naming style
*/

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
extern fn void cJson_InitHooks(Cjson_Hooks* hooks) @extern("cJSON_Hooks");


/* Supply a block of JSON, and this returns a Cjson object you can interrogate. Call Cjson_Delete when finished. */
extern fn Cjson *cJSON_Parse(ZString value) @extern("cJSON_Parse");
/* Render a Cjson entity to text for transfer/storage. Free the char* when finished. */
extern fn ZString cJSON_Print(Cjson *item) @extern("cJSON_Print");
/* Render a Cjson entity to text for transfer/storage without any formatting. Free the char* when finished. */
extern fn ZString cJSON_PrintUnformatted(Cjson *item) @extern("cJSON_PrintUnformatted");
/* Render a Cjson entity to text using a buffered strategy. prebuffer is a guess at the final size. guessing well reduces reallocation. fmt=0 gives unformatted, =1 gives formatted */
extern fn ZString cJSON_PrintBuffered(Cjson *item,int prebuffer,int fmt) @extern("cJSON_PrintBuffered");
/* Delete a Cjson entity and all subentities. */
extern fn void   cJSON_Delete(Cjson *c) @extern("cJSON_Delete");

/* Returns the number of items in an array (or object). */
extern fn int	  cJSON_GetArraySize(Cjson *array) @extern("cJSON_GetArraySize");
/* Retrieve item number "item" from array "array". Returns NULL if unsuccessful. */
extern fn Cjson *cJSON_GetArrayItem(Cjson *array,int item) @extern("cJSON_GetArrayItem");
/* Get item "string" from object. Case insensitive. */
extern fn Cjson *cJSON_GetObjectItem(Cjson *obj,ZString string) @extern("cJSON_GetObjectItem");

/* For analysing failed parses. This returns a pointer to the parse error. You'll probably need to look a few chars back to make sense of it. Defined when Cjson_Parse() returns 0. 0 when Cjson_Parse() succeeds. */
extern fn ZString cJSON_GetErrorPtr() @extern("cJSON_GetErrorPtr");
	
/* These calls create a Cjson item of the appropriate type. */
extern fn Cjson *cJSON_CreateNull() @extern("cJSON_CreateNull");
extern fn Cjson *cJSON_CreateTrue() @extern("cJSON_CreateTrue");
extern fn Cjson *cJSON_CreateFalse() @extern("cJSON_CreateFalse");
extern fn Cjson *cJSON_CreateBool(int b) @extern("cJSON_CreateBool");
extern fn Cjson *cJSON_CreateNumber(double num) @extern("cJSON_CreateNumber");
extern fn Cjson *cJSON_CreateString(ZString string) @extern("cJSON_CreateString");
extern fn Cjson *cJSON_CreateArray() @extern("cJSON_CreateArray");
extern fn Cjson *cJSON_CreateObject() @extern("cJSON_CreateObject");

/* These utilities create an Array of count items. */
extern fn Cjson *cJSON_CreateIntArray(int *numbers,int count) @extern("cJSON_CreateIntArray");
extern fn Cjson *cJSON_CreateFloatArray(float *numbers,int count) @extern("cJSON_CreateFloatArray");
extern fn Cjson *cJSON_CreateDoubleArray(double *numbers,int count) @extern("cJSON_CreateDoubleArray");
extern fn Cjson *cJSON_CreateStringArray(char **strings,int count) @extern("cJSON_CreateStringArray");

/* Append item to the specified array/object. */
extern fn void  cJSON_AddItemToArray(Cjson *array, Cjson *item) @extern("cJSON_AddItemToArray");
extern fn void	cJSON_AddItemToObject(Cjson *object,ZString string,Cjson *item) @extern("cJSON_AddItemToObject");
extern fn void	cJSON_AddItemToObjectCS(Cjson *object,ZString string,Cjson *item) @extern("cJSON_AddItemToObjectCS");	/* Use this when string is definitely const (i.e. a literal, or as good as), and will definitely survive the Cjson object */
/* Append reference to item to the specified array/object. Use this when you want to add an existing Cjson to a new Cjson, but don't want to corrupt your existing Cjson. */
extern fn void  cJSON_AddItemReferenceToArray(Cjson *array, Cjson *item) @extern("cJSON_AddItemReferenceToArray");
extern fn void	cJSON_AddItemReferenceToObject(Cjson *object,ZString string,Cjson *item) @extern("cJSON_AddItemReferenceToObject");

/* Remove/Detatch items from Arrays/Objects. */
extern fn Cjson *cJSON_DetachItemFromArray(Cjson *array,int which) @extern("cJSON_DetachItemFromArray");
extern fn void   cJSON_DeleteItemFromArray(Cjson *array,int which) @extern("cJSON_DeleteItemFromArray");
extern fn Cjson *cJSON_DetachItemFromObject(Cjson *object,ZString string) @extern("cJSON_DetachItemFromObject");
extern fn void   cJSON_DeleteItemFromObject(Cjson *object,ZString string) @extern("cJSON_DeleteItemFromObject");
	
/* Update array items. */
extern fn void cJSON_InsertItemInArray(Cjson *array,int which,Cjson *newitem) @extern("cJSON_InsertItemInArray");	/* Shifts pre-existing items to the right. */
extern fn void cJSON_ReplaceItemInArray(Cjson *array,int which,Cjson *newitem) @extern("cJSON_ReplaceItemInArray");
extern fn void cJSON_ReplaceItemInObject(Cjson *object,ZString string,Cjson *newitem) @extern("cJSON_ReplaceItemInObject");

/* Duplicate a Cjson item */
extern fn Cjson *cJSON_Duplicate(Cjson *item,int recurse) @extern("cJSON_Duplicate");
/* Duplicate will create a new, identical Cjson item to the one you pass, in new memory that will
need to be released. With recurse!=0, it will duplicate any children connected to the item.
The item->next and ->prev pointers are always zero on return from Duplicate. */

/* ParseWithOpts allows you to require (and check) that the JSON is null terminated, and to retrieve the pointer to the final byte parsed. */
extern fn Cjson *cJSON_ParseWithOpts(ZString value,ZString[] return_parse_end,int require_null_terminated) @extern("cJSON_ParseWithOpts");

extern fn void cJSON_Minify(ZString json) @extern("cJSON_Minify");

/* Macros for creating things quickly. */
macro cJSON_AddNullToObject(obj,name)	=>	cJSON_AddItemToObject(obj, (ZString)name, cJSON_CreateNull());
macro cJSON_AddTrueToObject(obj,name)	=>	cJSON_AddItemToObject(obj, (ZString)name, cJSON_CreateTrue());
macro cJSON_AddFalseToObject(obj,name)	=>	cJSON_AddItemToObject(obj, (ZString)name, cJSON_CreateFalse());
macro cJSON_AddBoolToObject(obj,name,b)	=>  cJSON_AddItemToObject(obj, (ZString)name, cJSON_CreateBool(b));
macro cJSON_AddNumberToObject(obj,name,n)=>	cJSON_AddItemToObject(obj, (ZString)name, cJSON_CreateNumber(n));
macro cJSON_AddStringToObject(obj,name,s)=>	cJSON_AddItemToObject(obj, (ZString)name,cJSON_CreateString((ZString)s));

/* When assigning an integer value, it needs to be propagated to valuedouble too. */
macro cJSON_SetIntValue(obj,val)		=>	obj?obj.valueint=obj.valuedouble=val:val;
macro cJSON_SetNumberValue(obj,val)	=>	obj?obj.valueint=obj.valuedouble=val:val;

