clc; clear; close all; warning off all;

%memanggil menu "browse file"
[nama_file, nama_folder] = uigetfile('*.jpg');

%jika ada nama file yang dipilih maka akan mengeksekusi perintah dibawah
%ini
if ~isequal(nama_file,0)
    %membaca fike citra RGB
    img = imread(fullfile(nama_folder, nama_file));
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
    data_uji(1, 1) = sum(sum(h))/sum(sum(bw));
    data_uji(1, 2) = sum(sum(h))/sum(sum(bw));
    
    %memanggil model hasil pelatihan
    load Mdl

    %membaca kelas keluaran hasil pengujian
    kelas_keluaran = predict(Mdl, data_uji);
    
    %manampilkan citra asli dan kelas keluaran hasil pengujian
    figure, imshow(img)
    title({['Nama File: ', nama_file], ['Kelas Keluaran: ', kelas_keluaran{1}]})
else
    %jika tidak ada nama file yang dipilih maka akan kembali
    return
end