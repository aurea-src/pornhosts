# pornhosts -- a consolidated anti porn hosts file

This is an endeavour to find all porn domains and compile them into a single hosts to allow for easy blocking of porn on your local machine or on a network.

In order to add this to your machine, copy the  [hosts](https://raw.githubusercontent.com/Clefspeare13/pornhosts/master/0.0.0.0/hosts), and add it to your ```hosts``` file which can be found in the following locations

macOS X, iOS, Android, Linux: /etc/hosts folder.

Windows: %SystemRoot%\system32\drivers\etc\hosts folder.

There are two ```hosts``` files in this repo, one which uses ```0.0.0.0``` and one which uses ```127.0.0.1```. If you are not sure which is right, use ```0.0.0.0``` as it is faster and will run on essentially all machines. However, if you know what you're doing and need a ```127.0.0.1``` version, it is available [here](https://raw.githubusercontent.com/Clefspeare13/pornhosts/master/127.0.0.1/hosts)

Additionally, there is a new hosts file which will force Safe Search in Bing and Google, however it has not been tested yet. It can be found [here](https://raw.githubusercontent.com/Clefspeare13/pornhosts/master/0.0.0.0%20%2B%20SafeSearch%20(beta)/hosts)

Any helpful additions are appreciated

## Why should I contribute
You should contribute to this list because it does matter for those who have to block this kind of content.
Let's have a look at Cloudflares <https://cloudflare-dns.com/family/> so called adult filter running on `1.1.1.3`

![Cloudflare-dns adult filtering](https://www.mypdns.com/file/data/lethgvoookfqugdffqjk/PHID-FILE-fsnlpmklbe5rnalbjlip/preview-image.png)

From the test file <https://github.com/Clefspeare13/pornhosts/blob/master/0.0.0.0/hosts> which we are going to use for our test we see the following result and why it matters you are contributing.

## Test result

```
Status      Percentage   Numbers     
----------- ------------ ------------
ACTIVE      96%          8615        
INACTIVE    3%           356         
INVALID     0%           0           
```

## Conclusion
We can hereby conclude this project have knowledge to 8615 domains, which nobody else CloudFlare-dns dosn't
