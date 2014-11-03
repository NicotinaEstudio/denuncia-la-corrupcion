/**
 * Copyright 2014 Nicotina Estudio
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

package com.sfp.denuncialacorrupcion.service;

import java.io.OutputStream;

import org.springframework.stereotype.Service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

@Service
public class IQRServiceImpl implements IQRService {

	private static final String IMAGE_FORMAT = "png";

	public void generarCodigoQR(int ancho, int alto, String contenido, OutputStream outputStream) throws Exception { 
		
		String imageFormat = IMAGE_FORMAT; 
		BitMatrix bitMatrix = new QRCodeWriter().encode(contenido, BarcodeFormat.QR_CODE, ancho, alto);
		MatrixToImageWriter.writeToStream(bitMatrix, imageFormat, outputStream);     
	}
}