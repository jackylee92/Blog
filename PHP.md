## PHP

* curl

````
function curlPost($url, $data = []){
    $url = str_replace(' ','+',$url);
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "$url");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch,CURLOPT_TIMEOUT,3);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
````

* Ajax

````
$.ajax({
	url:'http://www.baidu.com',
	data:{name:'123'},
	type:'post',
	success:function(result){
		var data = eval('('+result+')');
		if(!data['res']){
			layer.msg(data['msg'],{time:2000,icon: 5});
			return false;
		}
	}
})
````
