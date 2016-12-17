Pod::Spec.new do |s|
  	s.name         = 'DLEmptyDataSet'
    s.version      = '1.0.0'
    s.summary      = 'emptyview of UITableView And UICollectionView'
    s.homepage     = 'https://github.com/ZengyiMa/DLEmptyDataSet'
    s.license      = 'MIT'
    s.authors      = {'MaZengyi' => 'semazengyi@gmail.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/ZengyiMa/DLEmptyDataSet.git', :tag => s.version}
    s.source_files = 'DLEmptyDataSet/*.{h,m}'
    s.requires_arc = true
end
