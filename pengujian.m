clc; clear; close all; warning off all;

%%%Pengujian
%menetapkan lokasi folder data uji
nama_folder = 'data uji';

%membaca nama file yang berekstensi jpg
nama_file = dir(fullfile(nama_folder, '*.jpg'));

%membaca jumplah file yang berektensi .jpg
jumplah_file = numel(nama_file);

%inisialisasi variabel data_uji dan kelas_latih
data_uji = zeros(jumplah_file,2);
kelas_uji = cell(jumplah_file,1);

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
    bw = a>140;
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
    data_uji(n, 1) = sum(sum(h))/sum(sum(bw));
    data_uji(n, 2) = sum(sum(h))/sum(sum(bw));
    
    
end


% menetapkan kelas uji
for k = 1:7
    kelas_uji{k} = 'aple';
end

for k = 8:15
    kelas_uji{k} = 'jeruk';
end

%memanggil model hasil pelatihan
load Mdl

%membaca kelas keluaran hasil pengujian
kelas_keluaran = predict(Mdl, data_uji);

%menghitung nilai akurasi pengujian
jumplah_benar = 0;
for k = 1:jumplah_file
    if isequal(kelas_keluaran{k}, kelas_uji{k})
        jumplah_benar = jumplah_benar + 1;
    end
end

akurasi_pengujian = jumplah_benar/jumplah_file*100