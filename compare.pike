int pos=0;
array ef1,ef2,srt;

void nextline(object self,int dir)
{
	pos+=dir;
	foreach (srt;int row;array para)
	{
		para=String.trim_all_whites(para[pos])/"\n";
		catch {ef1[row]->set_text(para[2]);};
		ef2[row]->set_text(para[-1]);
	}
}

int main(int argc,array(string) argv)
{
	GTK2.setup_gtk();
	GTK2.Table tb=GTK2.Table(0,0,0);
	array files=argc>1 ? argv[1..] : sort(glob("*-*.srt",get_dir()));
	array english=glob("English*",files); files=english+(files-english); //If the English file is in the list, move it to the top
	ef1=allocate(sizeof(files));
	ef2=allocate(sizeof(files));
	srt=allocate(sizeof(files));
	GTK2.Button prev,next;
	foreach (files;int row;string fn)
	{
		sscanf(utf8_to_string(fn),"%s - %s.srt",string lang,string titl);
		tb->attach(GTK2.Label((["label":lang,"xalign":1.0])),0,1,row,row+1,GTK2.Fill,GTK2.Fill,1,1);
		tb->attach(GTK2.Label((["label":titl,"xalign":0.5])),1,2,row,row+1,GTK2.Fill,GTK2.Fill,1,1);
		tb->attach(ef1[row]=GTK2.Entry(),2,3,row,row+1,GTK2.Fill|GTK2.Expand,GTK2.Fill|GTK2.Expand,1,1);
		tb->attach(ef2[row]=GTK2.Entry(),3,4,row,row+1,GTK2.Fill|GTK2.Expand,GTK2.Fill|GTK2.Expand,1,1);
		srt[row]=(utf8_to_string(Stdio.read_file(fn))/"\n\n")[2..];
	}
	tb->attach(GTK2.HbuttonBox()
		->add(prev=GTK2.Button("_Prev")->set_use_underline(1))->add(next=GTK2.Button("_Next")->set_use_underline(1)),
	0,4,sizeof(files),sizeof(files)+1,GTK2.Fill|GTK2.Expand,GTK2.Fill|GTK2.Expand,1,1);
	prev->signal_connect("clicked",nextline,-1);
	next->signal_connect("clicked",nextline,1);
	nextline(0,0);
	GTK2.Window(0)->set_title("Translation comparison")->add(tb)->show_all()->signal_connect("destroy",lambda() {exit(0);});
	return -1;
}
