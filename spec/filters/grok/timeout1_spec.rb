require "spec_helper"
require "grok-pure"
require "timeout"

describe "grok known timeout failures" do
  describe "more apache log timeouts" do
    subject { Grok.new }
    before :each do
      patterns = Dir.glob(File.join(File.dirname(__FILE__), "../../../patterns/*"))
      patterns.each { |path| subject.add_patterns_from_file(path) }
      subject.add_pattern("RESPONSE_BYTES", '[0-9_-]+')
      subject.add_pattern("POST_CONN_STATUS", '[+-X]')
      subject.add_pattern("CUSTOMAPACHELOG", '%{HOSTNAME:servername} %{IP:remote_host} %{NONNEGINT:servetime_secs} \[%{HTTPDATE:apache_timestamp}\] \"%{WORD:method} %{URIPATH:url}\" %{QS:query} %{POSINT:status} %{RESPONSE_BYTES:bytes} %{POST_CONN_STATUS:post_conn_status} \"(?:%{URI:referrer}|-)\" %{QS:agent} %{QS:cookie}')
      subject.compile("%{CUSTOMAPACHELOG}")
    end

    it "should not timeout" do
      data = File.open(__FILE__); data.each { |line| break if line == "__END__\n" }
      # puts subject.expanded_pattern
      data.each do |line|
        # This timeout will toss an exception if it takes too long.
        Timeout.timeout(1) do
          subject.match(line.chomp)
          # puts :matched => subject.match(line.chomp)
        end
      end
    end
  end
end

__END__
example.com 11.22.33.44 1 [24/Oct/2012:08:47:14 +0200] "GET /need-russia-foo.php" "?login=100536&gclid=CJHRrKeHmbMCFWbKtAodn24ArA" 200 145492 + "http://www.google.de/#hl=de&sclient=psy-ab&q=foo+russland+kosten&oq=foo+rus&gs_l=hp.1.1.0l4.0.0.1.297.0.0.0.0.0.0.0.0..0.0...0.0...1c.uULgSTd5tzc&pbx=1&bav=on.2,or.r_gc.r_pw.r_qf.&fp=c4affe4f526437d4&bpcl=35466521&biw=1600&bih=799" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4" "Cookie: -" "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" "Lang: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" "Encoding: gzip,deflate,sdch" "Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
example.com 11.22.33.44 0 [24/Oct/2012:08:47:18 +0200] "GET /ajax/ajax.fillPurposes2.php" "?destination=RUS&nationality=DEU&state=&localCode=DE" 200 271 + "http://example.com/need-russia-foo.php?login=100536&gclid=CJHRrKeHmbMCFWbKtAodn24ArA" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4" "Cookie: PHPSESSID=b9bctuvsf2bdjcorbpogdkbll6p4p8uj; code=100536; __utma=256812172.1575809976.1351061239.1351061239.1351061239.1; __utmb=256812172.2.10.1351061239; __utmc=256812172; __utmz=256812172.1351061239.1.1.utmgclid=CJHRrKeHmbMCFWbKtAodn24ArA|utmccn=(not%20set)|utmcmd=(not%20set)|utmctr=foo%20russland%20kosten; __utmv=256812172.100536" "Accept: application/json, text/javascript, */*; q=0.01" "Lang: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" "Encoding: gzip,deflate,sdch" "Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
example.com 11.22.33.44 0 [24/Oct/2012:08:49:30 +0200] "GET /ajax/ajax.fillPurposes2.php" "?destination=RUS&nationality=DEU&state=Baden-W%C3%BCrttemberg&localCode=DE" 200 271 + "http://example.com/need-russia-foo.php?login=100536&gclid=CJHRrKeHmbMCFWbKtAodn24ArA" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4" "Cookie: PHPSESSID=b9bctuvsf2bdjcorbpogdkbll6p4p8uj; code=100536; __utma=256812172.1575809976.1351061239.1351061239.1351061239.1; __utmb=256812172.2.10.1351061239; __utmc=256812172; __utmz=256812172.1351061239.1.1.utmgclid=CJHRrKeHmbMCFWbKtAodn24ArA|utmccn=(not%20set)|utmcmd=(not%20set)|utmctr=foo%20russland%20kosten; __utmv=256812172.100536" "Accept: application/json, text/javascript, */*; q=0.01" "Lang: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" "Encoding: gzip,deflate,sdch" "Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
example.com 11.22.33.44 0 [24/Oct/2012:08:49:41 +0200] "GET /ajax/ajax.fooPopup.php" "?passport_from=DEU&state_of_residence=Baden-W%C3%BCrttemberg&traveling_to[0]=RUS&traveling_for%5B0%5D=P&traveling_to%5B1%5D=&traveling_for%5B1%5D=&traveling_to%5B2%5D=&traveling_for%5B2%5D=&traveling_to%5B3%5D=&traveling_for%5B3%5D=&account_number=100536&account_exists=N" 200 2459 + "http://example.com/need-russia-foo.php?login=100536&gclid=CJHRrKeHmbMCFWbKtAodn24ArA" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4" "Cookie: PHPSESSID=b9bctuvsf2bdjcorbpogdkbll6p4p8uj; code=100536; __utma=256812172.1575809976.1351061239.1351061239.1351061239.1; __utmb=256812172.2.10.1351061239; __utmc=256812172; __utmz=256812172.1351061239.1.1.utmgclid=CJHRrKeHmbMCFWbKtAodn24ArA|utmccn=(not%20set)|utmcmd=(not%20set)|utmctr=foo%20russland%20kosten; __utmv=256812172.100536" "Accept: text/html, */*; q=0.01" "Lang: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" "Encoding: gzip,deflate,sdch" "Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
example.com 11.22.33.44 0 [24/Oct/2012:08:49:45 +0200] "GET /ajax/ajax.fooPopupValid.php" "?codeId=1588744&countryCode=RUS&travelingFor=P&entry=S&passportFrom=DEU&_=1351061386611" 200 490 + "http://example.com/need-russia-foo.php?login=100536&gclid=CJHRrKeHmbMCFWbKtAodn24ArA" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4" "Cookie: PHPSESSID=b9bctuvsf2bdjcorbpogdkbll6p4p8uj; code=100536; __utma=256812172.1575809976.1351061239.1351061239.1351061239.1; __utmb=256812172.2.10.1351061239; __utmc=256812172; __utmz=256812172.1351061239.1.1.utmgclid=CJHRrKeHmbMCFWbKtAodn24ArA|utmccn=(not%20set)|utmcmd=(not%20set)|utmctr=foo%20russland%20kosten; __utmv=256812172.100536" "Accept: text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01" "Lang: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" "Encoding: gzip,deflate,sdch" "Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
example.com 11.22.33.44 0 [24/Oct/2012:08:49:50 +0200] "POST /ajax/ajax.fooPopup.php" "" 302 - + "http://example.com/need-russia-foo.php?login=100536&gclid=CJHRrKeHmbMCFWbKtAodn24ArA" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4" "Cookie: PHPSESSID=b9bctuvsf2bdjcorbpogdkbll6p4p8uj; code=100536; __utma=256812172.1575809976.1351061239.1351061239.1351061239.1; __utmb=256812172.2.10.1351061239; __utmc=256812172; __utmz=256812172.1351061239.1.1.utmgclid=CJHRrKeHmbMCFWbKtAodn24ArA|utmccn=(not%20set)|utmcmd=(not%20set)|utmctr=foo%20russland%20kosten; __utmv=256812172.100536" "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" "Lang: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" "Encoding: gzip,deflate,sdch" "Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
example.com 11.22.33.44 1 [24/Oct/2012:08:49:50 +0200] "GET /requirements.php" "" 200 23780 + "http://example.com/need-russia-foo.php?login=100536&gclid=CJHRrKeHmbMCFWbKtAodn24ArA" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4" "Cookie: PHPSESSID=b9bctuvsf2bdjcorbpogdkbll6p4p8uj; code=100536; __utma=256812172.1575809976.1351061239.1351061239.1351061239.1; __utmb=256812172.2.10.1351061239; __utmc=256812172; __utmz=256812172.1351061239.1.1.utmgclid=CJHRrKeHmbMCFWbKtAodn24ArA|utmccn=(not%20set)|utmcmd=(not%20set)|utmctr=foo%20russland%20kosten; __utmv=256812172.100536" "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" "Lang: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" "Encoding: gzip,deflate,sdch" "Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
example.com 11.22.33.44 1 [24/Oct/2012:08:49:52 +0200] "GET /ajax/ajax.requirementsFeesTable.php" "?text=RUS_0" 200 1406 + "http://example.com/requirements.php" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.94 Safari/537.4" "Cookie: PHPSESSID=b9bctuvsf2bdjcorbpogdkbll6p4p8uj; code=100536; __utma=256812172.1575809976.1351061239.1351061239.1351061239.1; __utmb=256812172.2.10.1351061239; __utmc=256812172; __utmz=256812172.1351061239.1.1.utmgclid=CJHRrKeHmbMCFWbKtAodn24ArA|utmccn=(not%20set)|utmcmd=(not%20set)|utmctr=foo%20russland%20kosten; __utmv=256812172.100536; 100536-AB-/eta-requirements=%2Feta-requirements; 100536-AB-/esta-requirements=%2Festa-requirements" "Accept: */*" "Lang: de-DE,de;q=0.8,en-US;q=0.6,en;q=0.4" "Encoding: gzip,deflate,sdch" "Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
example.com 194.127.209.156 0 [24/Oct/2012:10:54:06 +0200] "GET /ajax/ajax.fillPurposes2.php" "?destination=SAU&nationality=AUT&state=&localCode=DE" 200 236 + "http://example.com/foo.php?traveling_to=SAU&traveling_for=B&nationality=AUT&login=524412&state_of_residence=Baden-W\xc3\xbcrttemberg&use_lang=de&utm_source=trans&utm_medium=email&utm_campaign=cir-foo" "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)" "Cookie: PHPSESSID=h9gbvo04nomip8ca5ljko3cprrkttq9 ; code=524412" "Accept: application/json, text/javascript, */*; q=0.01" "Lang: de" "Encoding: gzip, deflate" "Charset: -"