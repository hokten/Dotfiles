#!/usr/bin/env bash
#
#   Script used to change volume level.
#   Script is bound to function volume keys by i3 in its configuration file.
#   
#   REQUIRES: pactl, lemonbar (popup alias)
#################################################################################
duration=2
#renkler=("#D38312" "#D28112" "#D28013" "#D17F14" "#D17D15" "#D07C16" "#D07B17" "#D07917" "#CF7818" "#CF7719" "#CE751A" "#CE741B" "#CE731C" "#CD711C" "#CD701D" "#CC6F1E" "#CC6E1F" "#CC6C20" "#CB6B21" "#CB6A21" "#CA6822" "#CA6723" "#C96624" "#C96425" "#C96326" "#C86227" "#C86027" "#C75F28" "#C75E29" "#C75D2A" "#C65B2B" "#C65A2C" "#C5592C" "#C5572D" "#C5562E" "#C4552F" "#C45330" "#C35231" "#C35131" "#C34F32" "#C24E33" "#C24D34" "#C14B35" "#C14A36" "#C04936" "#C04837" "#C04638" "#BF4539" "#BF443A" "#BE423B" "#BE413C" "#BE403C" "#BD3E3D" "#BD3D3E" "#BC3C3F" "#BC3A40" "#BC3941" "#BB3841" "#BB3742" "#BA3543" "#BA3444" "#B93345" "#B93146" "#B93046" "#B82F47" "#B82D48" "#B72C49" "#B72B4A" "#B7294B" "#B6284B" "#B6274C" "#B5254D" "#B5244E" "#B5234F" "#B42250" "#B42051" "#B31F51" "#B31E52" "#B31C53" "#B21B54" "#B21A55" "#B11856" "#B11756" "#B01657" "#B01458" "#B01359" "#AF125A" "#AF115B" "#AE0F5B" "#AE0E5C" "#AE0D5D" "#AD0B5E" "#AD0A5F" "#AC0960" "#AC0760" "#AC0661" "#AB0562" "#AB0363" "#AA0264" "#AA0165" "#AA0066")
renkler=("#FADA23" "#F9D723" "#F8D524" "#F7D325" "#F6D125" "#F6CF26" "#F5CC27" "#F4CA27" "#F3C828" "#F2C629" "#F2C429" "#F1C22A" "#F0BF2B" "#EFBD2B" "#EEBB2C" "#EEB92D" "#EDB72D" "#ECB42E" "#EBB22F" "#EAB02F" "#EAAE30" "#E9AC31" "#E8AA31" "#E7A732" "#E6A533" "#E6A333" "#E5A134" "#E49F35" "#E39C35" "#E29A36" "#E29837" "#E19637" "#E09438" "#DF9239" "#DE8F39" "#DE8D3A" "#DD8B3B" "#DC893B" "#DB873C" "#DA843D" "#DA823D" "#D9803E" "#D87E3F" "#D77C3F" "#D67A40" "#D67741" "#D57541" "#D47342" "#D37143" "#D26F43" "#D26D44" "#D16A45" "#D06845" "#CF6646" "#CE6447" "#CE6247" "#CD5F48" "#CC5D49" "#CB5B49" "#CA594A" "#CA574B" "#C9554B" "#C8524C" "#C7504D" "#C64E4D" "#C64C4E" "#C54A4F" "#C4474F" "#C34550" "#C24351" "#C24151" "#C13F52" "#C03D53" "#BF3A53" "#BE3854" "#BE3655" "#BD3455" "#BC3256" "#BB2F57" "#BA2D57" "#BA2B58" "#B92959" "#B82759" "#B7255A" "#B6225B" "#B6205B" "#B51E5C" "#B41C5D" "#B31A5D" "#B2175E" "#B2155F" "#B1135F" "#B01160" "#AF0F61" "#AE0D61" "#AE0A62" "#AD0863" "#AC0663" "#AB0464" "#AA0265" "#AA0066")
# define geometry
barw=420
barh=140
barx=$(xdpyinfo | grep dimensions | tr -s ' ' ';' | cut -f 3 -d ';' | cut -f 1 -d 'x')
bary=$(xdpyinfo | grep dimensions | tr -s ' ' ';' | cut -f 3 -d ';' | cut -f 2 -d 'x')
let barx=${barx}/2-${barw}/2
let bary=${bary}/2-${barh}/2

volume_step=5
function send_notify(){
  while [[ $(pgrep lemonbar) != "" ]]; do
    kill -s SIGTERM $(pgrep dzen)
  done
  cur_vol=$(get_current_volume)
  if [[ $(speaker_status) == "yes" ]]; then
    vol_text="^ib(1)^fg(#bfd8bd)^r(420x140)^fg(#dde7c7)^p(_LEFT)^p(30)^r(416x136)^p(_CENTER)^fg(red)cccc^fn(Material\-Design\-Iconic\-Font-45)^pa(138;6)^fg(#AA0066)\uf3bb^p(_LEFT)^p(;70)^fg(#bfd8bd)^r(402x24)^p(_LEFT)^p(1;1)^fg(#edeec9)^r(400x22)^p(_LEFT)^p(1;1)"
    for ((i=1;i<=$cur_vol;i++));
    do
      vol_text+="^fg(${renkler[$i]})^p(1)^r(3x20)"
    done
  else
    vol_text="^ib(1)^fg(#bfd8bd)^r(420x140)^fg(#dde7c7)^p(_LEFT)^p(-3)^r(416x136)^fn(Material\-Design\-Iconic\-Font-45)^p(_TOP)^p(_LEFT)^p(160)^fg(#AA0066)\uf3bc^p(_LEFT)^p(;70)^fg(#bfd8bd)^r(402x24)^p(_LEFT)^p(1;1)^fg(#edeec9)^r(400x22)^p(_LEFT)^p(1;1)"
    for ((i=1;i<=$cur_vol;i++));
    do
      vol_text+="^fg(${renkler[$i]})^p(1)^r(3x20)"
    done
  fi
  echo -e "${vol_text}^p(_LEFT)^p(170;20)^fg(#00a676)^fn(TeX Gyre Adventor-15:Bold) ${cur_vol}%"
}

function get_current_volume(){
  volume_level=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
  if [[ $volume_level -gt 100 ]]; then
    volume_level=100
  fi
  echo $volume_level
}

function speaker_status(){
  pacmd list-sinks | awk '/muted/ { print $2 }'
}

if [[ $1 == 1 && $(get_current_volume) -lt 100 ]]; then
  pactl list short sinks | cut -f1 | while read -r line; do pactl set-sink-volume $line +${volume_step}%; done
elif [[ $1 == 0 ]]; then
  pactl list short sinks | cut -f1 | while read -r line; do pactl set-sink-volume $line -${volume_step}%; done
elif [[ $1 == -1 ]]; then
  pactl list short sinks | cut -f1 | while read -r line; do pactl set-sink-mute $line toggle; done
fi

send_notify | dzen2 -x ${barx} -y ${bary} -h ${barh} -w ${barw} -ta l -p ${duration}

