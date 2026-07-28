path="E:\data\shem\";
save_path="E:\tem_day_new\";
data_days=zeros(2,2,43);%Record Meltyear with data available in 1-6 and 7-12（Melt1983=1982/1983=19820701-19830630）
%orbitflag,seasonflag,yearflag

%%For data_days array
for i=1982:2024
    filename=strcat(path,num2str(i),'\*.nc');
    namelist = dir(filename);
    len=length(namelist);
    lon_list=zeros(1,321,321);
    lat_list=zeros(1,321,321);
  
   
    for t=1:len
        temp_name=strcat(path,num2str(i),'_new\',namelist(t).name);
        temp_split=strsplit(temp_name,"_");
        temp_orbit=temp_split(5);%0200 or 1400
        datatime=char(temp_split(6));
        datatime=datatime(2:9);
        temp_year=str2double(datatime(1:4));%Year
        temp_month=str2double(datatime(5:6));%Month
        temp_day=str2double(datatime(7:8));%Day
        if temp_year==1982 && temp_month<=6
        	continue;
        end
        if temp_year==2024 && temp_month>=7
        	break;
        end
        if temp_orbit=="0200"
            if temp_month<=6
                data_days(1,1,i-1982+1)=data_days(1,1,i-1982+1)+1;
            else
                data_days(1,2,i-1982+1)=data_days(1,2,i-1982+1)+1;
            end
        else
            if temp_month<=6
                data_days(2,1,i-1982+1)=data_days(2,1,i-1982+1)+1;
            else
                data_days(2,2,i-1982+1)=data_days(2,2,i-1982+1)+1;
            end
        end
    end
end
for i=1983:2024
    for orbit_num=1:2
        if orbit_num==1
            temp_1=load(strcat("E:\tem_day\",num2str(i-1),"_","tem_0200",".mat")).tem_list;
            temp_2=load(strcat("E:\tem_day\",num2str(i),"_","tem_0200",".mat")).tem_list;
            full_days=data_days(1,2,i-1982)+data_days(1,1,i-1982+1);
            tem_list=zeros(full_days,321,321);
            for k=1:full_days
                if k<=data_days(1,2,i-1982)
                    tem_list(k,:,:)=temp_1(k+data_days(1,1,i-1982),:,:);
                else
                    tem_list(k,:,:)=temp_2(k-data_days(1,2,i-1982),:,:);
                end
            end
            if i>=2022
                save(strcat(save_path,num2str(i),"_","tem_0200",".mat"),'tem_list');
            end
        else
            temp_1=load(strcat("E:\tem_day\",num2str(i-1),"_","tem_1400",".mat")).tem_list;
            temp_2=load(strcat("E:\tem_day\",num2str(i),"_","tem_1400",".mat")).tem_list;
            full_days=data_days(2,2,i-1982)+data_days(2,1,i-1982+1);
            tem_list=zeros(full_days,321,321);
            for k=1:full_days
                if k<=data_days(2,2,i-1982)
                    tem_list(k,:,:)=temp_1(k+data_days(2,1,i-1982),:,:);
                else
                    tem_list(k,:,:)=temp_2(k-data_days(2,2,i-1982),:,:);
                end
            end
            if i>=2022
                save(strcat(save_path,num2str(i),"_","tem_1400",".mat"),'tem_list');
            end
        end
    end
    disp(i);
end