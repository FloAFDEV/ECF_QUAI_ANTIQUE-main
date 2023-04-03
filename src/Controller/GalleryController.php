<?php

namespace App\Controller;

use App\Repository\GalleryRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class GalleryController extends AbstractController
{
    /**
     * @Route("/gallery", name="gallery")
     */

    public function nos_plats(GalleryRepository $galleryRepository): Response
    {
        $gallery = $galleryRepository->findAll();
            dd($gallery);

        return $this->render('home/index.html.twig', [
            'gallery' => $gallery
        ]);
    }
}
