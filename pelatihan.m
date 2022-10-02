clc; clear; close all; warning off all;

%%%pelatihan
%menetapkan lokasi folder data latih
nama_folder = 'data latih';

%membaca nama file yang berekstensi jpg
nama_file = dir(fullfile(nama_folder, '*.jpg'));

%membaca jumplah file yang berektensi .jpg
jumplah_file = numel(nama_file);

%inisialisasi variabel data_latih dan kelas_latih
data_latih = zeros(jumplah_file,2);
kelas_latih = cell(jumplah_file,1);

% melakukan pengolahan citra terhadap seluruh file
for n = 1:jumplah_file
    %membaca fike citra RGB
    img = imread(fullfile(nama_folder, nama_file(n).name));
    %figure, imshow(img)
    %melakukan konversi citra RGB menjadi citra L*a*b
    cform = makecform('srgb2lab');
    lab = applycform(img, cform);
    %figure, imshow(lab)
    % mengekstrak komponen a dari citra L*a*b
    a = lab(:,:,2);
    %figure, imshow(a)
    %melakukan thresholding terhadap komponen a
    bw = a > 140;
    %figure, imshow(bw)
    %melakukan operasi morfologi untuk menyempurnakan hasil segmentasi
    bw = imfill(bw, 'holes');
    %figure, imshow(bw)
    %konfersi citra RGB menjadi citra HSV
    hsv = rgb2hsv(img);
    %mengekstrak komponen h dan s dari citra HSV
    h = hsv(:,:,1); % Hue
    s = hsv(:,:,2) % Saturasi
    % mengubah nilai piksel background menjadi nol
    h(~bw) = 0;
    s(~bw) = 0;
    % menghitung rata2 nilai hue dan saturation
    data_latih(n, 1) = sum(sum(h))/sum(sum(bw));
    data_latih(n, 2) = sum(sum(h))/sum(sum(bw));
    
    
end


% menetapkan kelas latih
for k = 1:15
    kelas_latih{k} = 'aple';
end

for k = 16:25
    kelas_latih{k} = 'jeruk';
end

%melakukan pelatihan dengan algoritma linear discriminant analysis
Mdl = fitcdiscr(data_latih, kelas_latih);

%membaca kelas keluaran hasil pelatihan
kelas_keluaran = predict(Mdl, data_latih);

%menghitung nilai akurasi pelatihan
jumplah_benar = 0;
for k = 1:jumplah_file
    if isequal(kelas_keluaran{k}, kelas_latih{k})
        jumplah_benar = jumplah_benar + 1;
    end
end

akurasi_pelatihan = jumplah_benar/jumplah_file*100

%menyimpan model hasil pelatihan
save Mdl Mdl