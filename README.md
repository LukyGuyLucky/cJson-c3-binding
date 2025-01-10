# cJson-c3-binding
cJson.h to cjson.c3 binding to new language c3,c3c

Use at your own risk

There are two examples both converted from the original c samples test.c , test_0.c3 is keeping the original api name style,ie,cjson_apiFunctionHelper(); Inside test_0.c3 all c api has been converted to c3;

test_c3.c3 is adapting api names according to the guideline of c3 language binding writing, that is,the original api like cjson_apiFunctionHelper() will be apiFunctionHelper(), so that when using module name ,will be cjson::apiFunctionHelper().
