#include <linux/module.h>
#include <linux/config.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/delay.h>
#include <linux/miscdevice.h>
#include <linux/ioctl.h>
#include <linux/interrupt.h>
#include <linux/spinlock.h>
#include <linux/smp_lock.h>
#include <linux/poll.h>
#include <linux/sched.h>
#include <linux/ioport.h>
#include <linux/slab.h>
#include <asm/hardware.h>
#include <asm/io.h>
#include <asm/arch/irqs.h>
#include <asm/irq.h>
#include <asm/signal.h>
#include <asm/uaccess.h>
/*定义设备的从设备号*/
#define MYDRIVER_MINOR  174
/*定义设备相关数据结构*/
typedef struct _MYDRIVER_DEV
{
spinlock_t            dev_lock;
wait_queue_head_t     oWait;      
int                  open_count; 

}MYDRIVER_DEV, *PMYDRIVER_DEV;
/*定义设备状态数据结构*/
typedef struct _MYDRIVER_DEV_STATS
{
unsigned long         rx_intrs;
unsigned long         rx_errors;
unsigned long         rx_blocks;
unsigned long         rx_dropped;
unsigned long         tx_intrs;
unsigned long         tx_errors;
unsigned long         tx_missed;
unsigned long         tx_blocks;
unsigned long         tx_dropped;
}MYDRIVER_DEV_STATS, * MYDRIVER_DEV_STATS;
unsigned int IntInit=0;
/*定义设备open接口函数*/
static int mydriver_open(struct inode *inode, struct file * filp)
{
int  minor;
DBGPRINT("mydriver_open/n");
minor = MINOR(inode->i_rdev); 
if ( minor != MYDRIVER_MINOR )  { return -ENODEV; }

#ifdef MODULE
MOD_INC_USE_COUNT;    /*打开使用次数累加*/
#endif

mydriver_dev.open_count++;
if ( mydriver_dev.open_count == 1 )
{
DBGPRINT("mydriver_open: first opne/n");
/*第一次打开设备，在这里可以放些设备初始化代码*/
}
return 0;
}
/*定义设备close接口函数*/
static int mydriver_release(struct inode *inode, struct file *filp)
{
DBGPRINT("mydriver_release/n");
mydriver_dev.open_count--;
if ( mydriver_dev.open_count == 0 )
{
DBGPRINT("mydriver_release: last close/n");
/*设备彻底关闭，这里可以放一些使设备休眠，或者poweroff的代码*/
}
#ifdef MODULE
MOD_DEC_USE_COUNT;    /*打开次数递减*/
#endif
return 0;
}
/*定义设备read接口函数*/
static ssize_t mydriver_read(struct file *filp, char *buf, size_t size,
                   loff_t *offp)
{
if(size> 8192) size = 8192;
/* copy_to_user()*/
/*copy kernel space to user space. */ 
/*把数据从内核复制到用户空间的代码，可以根据实际添加*/
return size;                      /*返回字节数*/
}
/*定义设备write接口函数*/
static ssize_t mydriver_write(struct file *filp, const char *buf, size_t
                   size, loff_t *offp)
{
lock_kernel();
DBGPRINT("mydriver_write/n");
if(size> 8192)  size = 8192;
/*copy_from_user()*/
/*copy user space to kernel space. */   /*把数据从用户空间复制到内核空间*/
unlock_kernel();         
return size;                      /*返回字节数*/
}
/*定义设备ioctl接口函数*/
static int mydriver_ioctl(struct inode *inode, struct file *filp, unsigned
                   int cmd, unsigned long arg)
{
int  ret = 0;
DBGPRINT("mydriver_ioctl: cmd: 0x%x/n", cmd);
switch(cmd)
{
case cmd1:      /*命令字，注意幻数的使用*/
…..
break;
…..
case cmd3:
…..
break;
default:
DBGPRINT("mydriver_ioctl: bad ioctl cmd/n");
ret = -EINVAL;
break;
}
return ret;
}
/*定义设备select函数接口*/
static unsigned int mydriver_poll(struct file *filp, poll_table *wait)
{
poll_wait(filp,&mydriver_dev.oWait,wait);
if(IntInit)
{  
IntInit=0;
return POLLIN|POLLRDNORM;  //可以写
}
else {  return POLLOUT;      //可以读 }
}
/*定义设备的file_operations*/
static struct file_operations  mydriver_fops =
{
owner:      THIS_MODULE,
open:       mydriver_open,
release:     mydriver_release,
read:       mydriver_read,
write:      mydriver_write,
ioctl:       mydriver_ioctl,
poll:       mydriver_poll,
};
/*定义设备结构体*/
static struct miscdevice  mydriver_miscdev =
{
MYDRIVER_MINOR,
" mydriver ",
& mydriver_fops
};
/*定义设备init函数*/
int __init mydriver_init(void)
{
int  ret;
DBGPRINT("mydriver_init/n");
ret =misc_register(&mydriver_miscdev); //注意这里调用misc_register()来注册
if ( ret )
{
 DBGPRINT("misc_register failed: 0x%x/n", ret);
return ret;
}
memset(&mydriver_dev, 0, sizeof(mydriver_dev));
init_waitqueue_head(&mydriver_dev.oWait);
spin_lock_init(&mydriver_dev->dev_lock);
/*这里可以放一些硬件初始化的函数*/    
return 0;
}
/*定义设备exit函数*/
void __exit mydriver_exit(void)
{
DBGPRINT("mydriver_exit/n");
misc_deregister(&mydriver_miscdev);  //注销misc dev
}
module_init(mydriver_init);
module_exit(mydriver_exit);
MODULE_LICENSE("GPL");
