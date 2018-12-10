#!/bin/bash
# author: gfw-breaker

video_count=40

while getopts "f:u:s:a" arg; do
	case $arg in
		f)
			folder=$OPTARG
			;;
		u)
			youtube_url=$OPTARG
			;;
		s)
			stick=$OPTARG
			;;
		a)
			get_audio=1
			;;
	esac
done


video_dir=/usr/share/nginx/html/$folder
index_page=$video_dir/index.html
md_page=$video_dir/index.md

ip=$(/sbin/ifconfig | grep "inet addr" | sed -n 1p | cut -d':' -f2 | cut -d' ' -f1)
ts=$(date '+%m%d%H')


# download videos
mkdir -p $video_dir
cd $video_dir
echo -e "\n\n======================\n\n" >> dl.log
#youtube-dl -f 133+140 \
youtube-dl -f 18 \
	--max-downloads $video_count \
	--playlist-end 200 \
	-i $youtube_url >> dl.log

if [ $stick ]; then
	youtube-dl -f 18 -i "https://www.youtube.com/watch?v=$stick"
	touch *$stick*
fi


# remove old video files
ls -t *mp4 | grep -v ^link | sed -n '50,$p' > deleted.txt
while read v ; do
	echo "removing $v ..."
	rm "$v"
done < deleted.txt


# generate page
echo > $md_page
cat > $index_page << EOF
<html>
<head>
<meta charset="utf-8" /> 
</head>
<body>
EOF

ls -t *.mp4 | grep -v ^link > list.txt

while read v; do
	vid=$(echo $v | rev | cut -c5-15 | rev)
	name="link.$ts.$vid.mp4"
	title=$(echo $v | rev | cut -c17- | rev | sed 's/法轮功/法.轮.功/g' | sed 's/退/.退./g' | sed 's/党/.党/g' | sed 's/摘/.摘/g' ) 
	
	ln -s "$v" "$name" > /dev/null 2>&1
	echo "<a href='http://$ip/$folder/$name.html'><b>$title</b></a></br></br>" >> $index_page
	echo "##### <a href='http://$ip/$folder/$name.html'>$title</a>" >> $md_page

cat > $video_dir/$name.html << EOF
<html>
<head>
<title> $title </title>
<meta charset="UTF-8"> 
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script src="https://unpkg.com/video.js@6.7.3/dist/video.min.js"></script>
<script src="https://unpkg.com/videojs-contrib-hls@5.14.1/dist/videojs-contrib-hls.min.js"></script>
<link rel='stylesheet' id='videojs-css' href='https://unpkg.com/video.js@6.7.3/dist/video-js.min.css' type='text/css' media='all' />
<style>
h4 {
	margin-top: 20px;
}
#player {
	margin: 0 auto;
	margin-top: 20px;
	width: 100%;
	max-width: 640px;
	height: 360px;
}
@media (max-width : 700px) {
	#player {
		height: 220px;
	}
}
</style>
</head>
<body>
<h4><center>$title</center></h4>
<center>
<video id=player class="video-js vjs-default-skin vjs-big-play-centered" controls preload="auto" autoplay poster="/card.png">
  <source
     src="http://$ip:88/hls/$folder/$name/index.m3u8"
     type="application/x-mpegURL">
</video>
<script type="text/javascript">
    var player = videojs('player');
</script>
<p>
<a href="https://nogfw-007.herokuapp.com/proxy/http://www.zhuichaguoji.org/node/108500" target="_blank"><b>追查国际对中共活摘法轮功学员器官现状调查报告（七）（17个调查电话录音）</b></a>&nbsp;&nbsp;
<br/><br/>
<a href="https://github.com/gfw-breaker/nogfw/blob/master/README.md" target="_blank"><b>翻墙软件</b></a>&nbsp;&nbsp;
<a href="http://$ip" target="_blank"><b>新唐人电视直播</b></a>&nbsp;&nbsp;
<a href="http://$ip:10080" target="_blank"><b>大纪元新闻网</b></a>&nbsp;&nbsp;
<a href="http://$ip:8000" target="_blank"><b>新唐人电视台</b></a>&nbsp;&nbsp;
<a href="$name" target="_blank"><b>下载视频</b></a>&nbsp;&nbsp;
<a href="$vid.mp3" target="_blank"><b>下载音频</b></a>&nbsp;&nbsp;
<br/><br/>
<a href="http://$ip:10000/videos/world"><b>法轮大法洪传世界</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/blog/weihuo.html"><b>天安门自焚真相</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/blog/425event.html"><b>4.25中南海万人上访始末</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/blog/jiexi1400.html"><b>所谓"1400例"谎言揭秘</b></a>&nbsp;&nbsp;
<br/><br/>
<a href="https://github.com/gfw-breaker/wenzhao/blob/master/README.md"><b>《文昭谈古论今》</b></a>&nbsp;
<a href="https://github.com/gfw-breaker/ntdtv-comedy/blob/master/README.md"><b>《大陆新闻解读》</b></a>&nbsp;
<a href="https://github.com/gfw-breaker/ntdtv-news/blob/master/README.md"><b>《新唐人中国禁闻》</b></a>&nbsp;
<a href="https://github.com/gfw-breaker/today-in-history/blob/master/README.md"><b>《历史上的今天》</b></a>&nbsp;
<br/><br/>
<a href="http://$ip:10000/videos/legend/index.html"><b>《传奇时代》</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/fytdx/index.html"><b>《风雨天地行》</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/jiuping/index.html"><b>《九评共产党》</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/mtdwh/index.html"><b>《漫谈党文化》</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/bnhh/index.html"><b>《百年红祸》</b></a>&nbsp;&nbsp;
<br/><br/>
<a href="http://$ip:10000/videos/res/Organs"><b>中共摘取活体器官</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/709"><b>709维权律师大抓捕</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/res/TradeWar"><b>中美贸易战专题</b></a>&nbsp;&nbsp;
<br/><br/>
<a href="http://$ip:10000/videos/blog/tuid.html"><b>三退大潮席卷全球</b></a>&nbsp;&nbsp;
<a href="http://$ip:10080/gb/8/11/24/n2339512.htm"><b>文昭：生活在希望中，做快乐的中国人</b></a>
<br/><br/>
</p>
</center>
</body>
</html>
EOF

done < list.txt

echo "</body></html>" >> $index_page


# commit
plinks="##### 反向代理： [新唐人直播](http://$ip) &nbsp;|&nbsp; [Google](http://$ip:8888/search?q=425事件) &nbsp;|&nbsp; [维基百科](http://$ip:8100/wiki/喬高-麥塔斯調查報告) &nbsp;|&nbsp; [大纪元新闻网](http://$ip:10080) &nbsp;|&nbsp; [新唐人电视台](http://$ip:8000) &nbsp;|&nbsp; [我的博客](http://$ip:10000/) &nbsp;|&nbsp; [追查国际](http://$ip:10010)"
vlinks="##### 精彩视频： [《传奇时代》](http://$ip:10000/videos/legend/) | [《风雨天地行》](http://$ip:10000/videos/fytdx/) | [《九评共产党》](http://$ip:10000/videos/jiuping/) | [《漫谈党文化》](http://$ip:10000/videos/mtdwh/) | [《百年红祸》](http://$ip:10000/videos/bnhh) |&nbsp; [709维权律师](http://$ip:10000/videos/709/)"

sed -i "4 a$vlinks" $md_page
sed -i "4 a$plinks" $md_page


## clean up
cd $video_dir
dated=$(ls -t link*mp4 | sed -n '2000,$p')
for f in $dated; do
	echo "removing $f ..."
	rm $f
	rm $f.html
done


# push
cd /root/$folder
git pull
sed -i '5,$d' README.md
cat $md_page >> README.md
git commit -a -m 'ok'
git push


## convert audio
if [ "$get_audio" == "" ]; then
	exit
fi

cd $video_dir
while read v; do
	vid=$(echo $v | rev | cut -c5-15 | rev)
	audio="$vid.mp3"
	if [ -f "$audio" ]; then
		echo "skipping $audio ..."
		continue
	fi
	ffmpeg -i "$v" -b:a 64k -vn "$audio" </dev/null
done < list.txt

