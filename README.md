## Openstack-ansible-ocata  <br>
Auther   Erick <br>
简介：<br>
环境介绍：<br>
>本次安装Openstack 版本为Ocata版；<br>
>Ansible版本： <br>
>[root@ansible ansible]# ansible --version  <br>
ansible 2.4.1.0 <br>
config file = /etc/ansible/ansible.cfg <br>
configured module search path = [u'/etc/ansible/library'] <br>
ansible python module location = /usr/lib/python2.7/site-packages/ansible <br>
executable location = /usr/bin/ansible <br>
>python version = 2.7.5 (default, Aug  4 2017, 00:39:18) [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)] <br>

操作系统版本： <br>
目前测试过Centos7.2 和Centos7.4 均未有问题 <br>
Design Principles： <br>
支持单Controller 节点和多计算节点；支持单/双/三/网卡，网络为ovs模型； <br>
本次部署是用Ansible 批量部署，具有幂等性，所以可以重复执行； <br>
下面是整体的一个部署图： <br>


>>                             
>>                       - group/all           控制变量文件 
>>                      |
>> 
>>                      |
>>                
>>       fetch hosts    |
>>                                       |  - { role: commen,tags: commen }           
>>            |         |                |  - { role: memcached,tags: memcached }     
>>                      |                   - { role: mariadb,tags: mariadb }        
>>            |                          |  - { role: rabbitmq, tags: rabbitmq }     
>>                             controller   - { role: keystone, tags: keystone }    
>>                      |        |       |  - { role: glance, tags: glance }          
>>            |                  |          - { role: nova, tags: controller_nova }  
>>                      |                |  - { role: controller_neutron, tags: controller_neutron }
>>           |                           |  - { role: dashboard, tags: dashboard }
>ansible-playbook siete.yml                        
>>                               |        
>>                      |                  |         
>>                                         |
>>                      |-roles  |         | - { role: commen,tags: commen }  
>>                               compute                                              
>>                               |         | - { role: nova_compute, tags: compute_nova } 
>>                                         |          
>>                                         | - { role: compute_neutron, tags: nova_neutron }               
>>                                          
>>                                       
>>                               | controller | shell: su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova 
>>


详细步骤：(注：要保证被部署节点有互联网) <br>
1、修改host-1 这个文件把控制节点的ip、用户、密码写入；修改hosts_all_nodes 把所有的计算节点和控制节点的ip对应关系填入，此文件将是 /etc/hosts 文件 <br>
2、sh venv.sh  <br>
3、修改hosts 文件： <br>
[controller] <br>
192.168.1.2.206  mgmt=192.168.1.206  pub_nic=eno33559296  br_ex_addr=192.168.1.50 tunnel_ip=192.168.1.206  <br>
依次为部署网、管理网、外网的网卡名称、外网ip、租户网ip <br>
注： 我们支持单/双/三/网卡，所以可以复用 <br>
4、修改group/all 的变量，填充自己想用的密码；（注：作者在部署时碰到了特殊字符不能使用的问题，为了避免入坑，所以推荐使用大小写和数字） <br>
5、ansible-playbook site.yml -vv <br>

部署完后，登陆地址为： br_ex_addr:/dashboard <br>
登陆信息: default/admin/admin <br>

——
本项目持续更新<br>
---

如有问题请联系shihy_happy@163.com 


             
