package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.printing.PrintJob;
	import flash.net.URLLoader;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import com.adobe.images.JPGEncoder;

	public class fotoWebcam extends MovieClip 
		{
			public var imagemSalva;
			public var bandwidth:int = 0; 
			public var quality:int = 100; 
			public var cam:Camera = Camera.getCamera();
			public var video:Video = new Video();
			public var bitmapData:BitmapData;
			public var bitmap:Bitmap;
			public var containerWebcam:MovieClip;
			public var containerImagem:MovieClip;
			public var btnCaptaImagem:BtnImagem;
			public var btnImprimeImagem:BtnImagem;
			public var btnDonwloadImagem:BtnImagem;
			public var btnNovaImagem:BtnImagem;
	
			public function fotoWebcam() 
				{			
					//iniciando, adicionando e configurando a imagem da webcam no stage
					cam.setQuality(bandwidth, quality);
					cam.setMode(320,240,30,false); 
					video.attachCamera(cam);
					containerWebcam = new MovieClip();
					containerWebcam.addChild(video);
					containerWebcam.x = 0;
					containerWebcam.y = 0;
					addChild(containerWebcam);
					
					//adicionando e configurando o botão de captação da imagem no stage
					btnCaptaImagem = new BtnImagem();
					btnCaptaImagem.txtLabelBtn.text = "Capture a Imagem";		
					addChild(btnCaptaImagem);
					btnCaptaImagem.x = (containerWebcam.width / 2) - (btnCaptaImagem.width / 2);
					btnCaptaImagem.y = containerWebcam.height + 20;				
					btnCaptaImagem.buttonMode = true;
					btnCaptaImagem.addEventListener(MouseEvent.CLICK,capturaImage);				
				}
			
			public function capturaImage(e:MouseEvent):void 
				{
					//removendo o botão do stage
					btnCaptaImagem.removeEventListener(MouseEvent.CLICK,capturaImage);	
					removeChild(btnCaptaImagem);
				
					//adicionando a imagem salva no palco
					bitmapData = new BitmapData(video.width,video.height);
					bitmapData.draw(video);
					bitmap = new Bitmap(bitmapData);			
					containerImagem = new MovieClip();
					containerImagem.addChild(bitmap);
					addChild(containerImagem);
					containerImagem.x = containerWebcam.width + 50;
					containerImagem.y = containerWebcam.y;	
				
					//adicionando e configurando botão de impressão da imagem
					btnImprimeImagem = new BtnImagem();
					btnImprimeImagem.txtLabelBtn.text = "Imprima a Imagem";		
					addChild(btnImprimeImagem);
					btnImprimeImagem.x = (((containerImagem.width / 2) - (btnImprimeImagem.width / 2)) - 75) + containerImagem.x;
					btnImprimeImagem.y = containerImagem.height + 20;				
					btnImprimeImagem.buttonMode = true;
					btnImprimeImagem.addEventListener(MouseEvent.CLICK,imprimeImage);
					
					//adicionando e configurando botão para envio da imagem para o servidor
					btnDonwloadImagem = new BtnImagem();
					btnDonwloadImagem.txtLabelBtn.text = "Envia Imagem";		
					addChild(btnDonwloadImagem);
					btnDonwloadImagem.x = (((containerImagem.width / 2) - (btnDonwloadImagem.width / 2)) + 75) + containerImagem.x;
					btnDonwloadImagem.y = containerImagem.height + 20;				
					btnDonwloadImagem.buttonMode = true;
					btnDonwloadImagem.addEventListener(MouseEvent.CLICK,downloadImage);	
					
					//adicionando e configurando botão de retorno
					btnNovaImagem = new BtnImagem();
					btnNovaImagem.txtLabelBtn.text = "Nova Imagem";		
					addChild(btnNovaImagem);
					btnNovaImagem.x = ((containerImagem.width / 2) - (btnNovaImagem.width / 2)) + containerImagem.x;
					btnNovaImagem.y = btnDonwloadImagem.y + 75;				
					btnNovaImagem.buttonMode = true;
					btnNovaImagem.addEventListener(MouseEvent.CLICK,novaImage);
			}	
			
			//função responsável pela impressão da imagem
			public function imprimeImage(e:MouseEvent):void 
				{
					var imprimir:PrintJob = new PrintJob();
					if (imprimir.start()) 
						{
							if (containerImagem.width>imprimir.pageWidth) 
								{
									containerImagem.width = imprimir.pageWidth;
									containerImagem.scaleY = containerImagem.scaleX;
								}
							imprimir.addPage(containerImagem);
							imprimir.send();
						}
				}			
			
			//remove do palco a imagem captada e os botões
			public function novaImage(e:MouseEvent):void 
				{
					btnImprimeImagem.removeEventListener(MouseEvent.CLICK,imprimeImage);	
					removeChild(btnImprimeImagem);
					
					btnDonwloadImagem.removeEventListener(MouseEvent.CLICK,downloadImage);	
					removeChild(btnDonwloadImagem);
					
					btnNovaImagem.removeEventListener(MouseEvent.CLICK,novaImage);	
					removeChild(btnNovaImagem);
													
					removeChild(containerImagem);
					
					addChild(btnCaptaImagem);
					btnCaptaImagem.addEventListener(MouseEvent.CLICK,capturaImage);	
				}
			
			//envia a imagem para o servidor através do salvar.php
			public function downloadImage(e:MouseEvent):void 
				{
					var myEncoder:JPGEncoder = new JPGEncoder(100);
					var byteArray:ByteArray = myEncoder.encode(bitmapData);
					var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
					var salvaJPG:URLRequest = new URLRequest("salvar.php");
					
					salvaJPG.requestHeaders.push(header);
					salvaJPG.method = URLRequestMethod.POST;
					salvaJPG.data = byteArray;
					
					var urlLoader:URLLoader = new URLLoader();
					urlLoader.addEventListener(Event.COMPLETE, envioCompleto);
					urlLoader.load(salvaJPG);
				}
			
			//retorno após o envio da imagem para o servidor
			public function envioCompleto(event:Event):void
				{
					navigateToURL(new URLRequest("images/"), "_blank");
					trace("foto enviada!");
				}
	}	
}