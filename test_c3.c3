module test_c3;

import libc;

import cjson;

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
    
    json=cjson::parse(text);
    
    if(!json)
    {
        libc::printf("Error before:[%s]\n",cjson::getErrorPtr());
    }
    else
    {
        out=cjson::print(json);
        cjson::delete(json);
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
    
    root=cjson::createObject();
    cjson::addItemToObject(root,"name",cjson::createString("Jack (\"Bee\") Nimble"));
    cjson::addItemToObject(root,"format",fmt=cjson::createObject());
    cjson::addStringToObject(fmt,"type",              (ZString)"rect");
    cjson::addNumberToObject(fmt,"width",            1920);
    cjson::addNumberToObject(fmt,"height",           1080);
    cjson::addFalseToObject(fmt,"interface");
    cjson::addNumberToObject(fmt,"frame rate",       24);
    
    out=cjson::print(root);
    cjson::delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
    root=cjson::createStringArray(strings,7);
    out=cjson::print(root);
    cjson::delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
    root=cjson::createArray();
    for(i=0;i<3;i++)
    {
        cjson::addItemToArray(root,cjson::createIntArray(&numbers[i],3));
    }
    
    out=cjson::print(root);
    cjson::delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
    root=cjson::createObject();
    cjson::addItemToObject(root,"Image",img=cjson::createObject());
    cjson::addNumberToObject(img,"Width",800);
    cjson::addNumberToObject(img,"Height",600);
    cjson::addStringToObject(img,"Title","View from 15th Floor");
    cjson::addItemToObject(img,"Thumbnail",thm=cjson::createObject());
    cjson::addStringToObject(thm,"Url",(ZString)"http:/*www.example.com/image/481989943");
    cjson::addNumberToObject(thm,"Height",125);
    cjson::addStringToObject(thm,"Width","100");
    cjson::addItemToObject(thm,"IDs",cjson::createIntArray(&ids,4));
    
    out=cjson::print(root);
    cjson::delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
    root=cjson::createArray();
    for(i=0;i<2;i++)
    {
        cjson::addItemToArray(root,fld=cjson::createObject());
        cjson::addStringToObject(fld,"precision",fields[i].precision);
        cjson::addNumberToObject(fld,"Latitude",fields[i].lat);
        cjson::addNumberToObject(fld,"longtitude",fields[i].lon);
        cjson::addStringToObject(fld,"Address",fields[i].address);
        cjson::addStringToObject(fld,"Citu",fields[i].city);
        cjson::addStringToObject(fld,"State",fields[i].state);
        cjson::addStringToObject(fld,"Zip",fields[i].zip);
        cjson::addStringToObject(fld,"Country",fields[i].country);
    }
    out=cjson::print(root);
    cjson::delete(root);
    libc::printf("%s\n",out);
    libc::free(out);
    
}
fn void test2()
{
    create_object();
}