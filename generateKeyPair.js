const forge = require('node-forge');
const sshpk = require('sshpk');
const fs = require('fs');

function generateKeyPair() {
    // RSA 키 페어 생성
    forge.pki.rsa.generateKeyPair({ bits: 2048 }, function(err, keypair) {
        if (err) {
            console.error('키 페어 생성 중 오류 발생:', err);
            return;
        }

        // 개인 키 및 공개 키 추출
        const privateKey = forge.pki.privateKeyToPem(keypair.privateKey);
        let publicKey = forge.pki.publicKeyToPem(keypair.publicKey);

        // PEM 형식의 공개 키를 OpenSSH 형식으로 변환
        const sshKey = sshpk.parseKey(publicKey, 'pem');
        publicKey = sshKey.toString('ssh');

        // 파일로 저장
        fs.writeFileSync('privateKey.pem', privateKey, 'utf8');
        fs.writeFileSync('publicKey.pub', publicKey, 'utf8');  // OpenSSH 형식의 파일은 .pub 확장자 사용

        console.log('키 파일이 성공적으로 저장되었습니다.');
    });
}

// 함수 실행
generateKeyPair();
