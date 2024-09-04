using System;

namespace EBMSMap30
{
	/// <summary>
	/// Summary description for cRc4.
	/// </summary>
	public class cRc4
	{
		public cRc4()
		{
			//
			// TODO: Add constructor logic here
			//
		}
		int[] sbox=new int[256];
		int[] key =new int[256];
		
		void RC4Initialize(string strPwd)
		{
			int tempSwap;
			int a;
			int b,intLength;

			intLength = strPwd.Length; 
			for(a = 0;a<=255;a++)
			{
				string s=strPwd.Substring((a%intLength),1);			
				key[a] = (int)char.Parse(s);
				sbox[a] = a;
			}

			b = 0;
			for(a = 0;a<=255;a++)
			{
				b = (b + sbox[a] + key[a]) % 256;
				tempSwap = sbox[a];
				sbox[a] = sbox[b];
				sbox[b] = tempSwap;
			}
		}
		public string EnDeCrypt(string plaintxt,string psw)
		{
														  
			string cipher="";
			int temp;
			int a;
			int i;
			int j;
			int k;
			int cipherby;

			i = 0;
			j = 0;

			RC4Initialize(psw);

			for(a = 1;a<=plaintxt.Length;a++)
			{ 
				i = (i + 1)% 256;
				j = (j + sbox[i]) % 256;
				temp = sbox[i];
				sbox[i] = sbox[j];
				sbox[j] = temp;
				k = sbox[(sbox[i]+sbox[j])% 256];
				cipherby = (int)(char.Parse(plaintxt.Substring(a-1,1))) ^ k;
				cipher = cipher + (char)cipherby;
			}
			return cipher;
		}
	}
}
